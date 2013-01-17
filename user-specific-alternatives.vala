// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-

// $ valac --pkg granite app-by-mime.vala

// This code inherits update-alternatives terminology that may be not obvious
// It's recommented to read TERMINOLOGY in "man update-alternatives" before hacking

string real_path_to_self = null; //TODO: replace it with the path as seen in the alternatives system, possibly make it local

void usage () {
    stderr.printf ("Usage: you're not supposed to run this.

This is a wrapper that allows Debian alternatives system to launch the application preferred by a specific user instead of a system-wide and often implicit default, e.g. for \"x-www-browser\" alternative. It passes all parameters it receives as well as stdin to the user-preferred application, so launching it should be equivalent to launching the user-preferred application directly, except this wrapper exits as soon as it spawns the target app and DOES NOT wait until it finishes and returns an exit code.

To make this wrapper handle an alternative it already supports, simply register it for that alternative using update-alternatives.
Alternative detection is often generalized, e.g. everything containing \"www-browser\" is considered to be a GUI web browser.
To avoid \"www-browser\" launching GUI application even when a console browser is desired, simply do not install the wrapper for that alternative.

To expand the list of supported alternatives you'll have to add a custom handler of that alternative to the code of this wrapper.\n");
}

bool alternative_exists (string alternative_name) {
    //doesn't do any real validity checks, just checks if it exists
    return FileUtils.test ("/etc/alternatives/" + alternative_name, FileTest.EXISTS);
}

void set_real_path_to_self (string? invocation_path) {
    //sets global variable real_path_to_self
    //sets it to null if fails
    //procfs lookups taken from http://stackoverflow.com/questions/1023306/finding-current-executables-path-without-proc-self-exe/
    try { real_path_to_self = FileUtils.read_link ("/proc/self/exe"); } //Linux
    catch (FileError e) {
        try { real_path_to_self = FileUtils.read_link ("/proc/curproc/exe"); } //NetBSD
        catch (FileError e) { 
            try { real_path_to_self = FileUtils.read_link ("/proc/curproc/file"); } //DragonflyBSD
            catch (FileError e) {
                //damn incompatible implementations!
                warning ("Couldn't determine full path to self using procfs. Either procfs is disabled, or a lookup specific to your platform is not yet known to me. Falling back to lookup by invocation.");
                if (invocation_path != null) {
                    //FIXME: loop readlink over args[0] as a fallback because determine the alternative that way anyway
/*                    if (alternative_exists (alternative_name)) {
                        try { real_path_to_self = FileUtils.read_link ("/etc/alternatives/" + alternative_name); }
                        catch (FileError e) {
                        critical ("Couldn't determine full path to self neither using procfs nor by alternatives because \"%s\" alternative is misconfigured: either it's a dangling symbolic link, either it's not a symbolic link at all, or I don't have permissions to read it. Please report a bug to your distribution maintainers.", alternative_name);
                        }
                    } else {
                        critical ("Couldn't determine full path to self neither using procfs nor by alternatives because \"%s\" is not registered in Debian alternatives system. I'm not supposed to be invoked this way. Please report a bug to your distribution maintainers.", alternative_name);
                    }
*/
                } else {
                    critical ("Couldn't determine full path to self using procfs and skipping determining it by invocation path because none was passed to me.");
                }
            }
        }
    }
}

string? get_fallback_alternative (string alternative_name) {
    //returns null if fails
    string best_alternative_path = null;
    int highest_priority = 0;
    debug ("Determining fallback alternative for \"%s\"", alternative_name);
    string[] command = { "update-alternatives", "--query", alternative_name, "--quiet" };
    int stdout_descriptor;
    try {
        Process.spawn_async_with_pipes (null, command, null, SpawnFlags.SEARCH_PATH, null, null, null, out stdout_descriptor, null);
        var stream = FileStream.fdopen (stdout_descriptor, "r");
        assert (stream != null);
        if (real_path_to_self != null) {
            while (! stream.eof ()) {
                string line = stream.read_line ();
                const string alternative_prefix = "Alternative: ";
                if (line != null && line.has_prefix (alternative_prefix)) {
                    string alternative_path;
                    alternative_path = line.substring ( alternative_prefix.length, -1);
                    debug ("Found alternative path \"%s\";", alternative_path);
                    int priority;
                    stream.scanf ("Priority: %d", out priority); //never skip this!
                    debug ("its priority is \"%d\".", priority);
                    if ( alternative_path == real_path_to_self ) { debug ("Found self, skipping."); }
                    else if (best_alternative_path == null || priority > highest_priority) {
                        debug ("It's the best alternative path found so far.");
                        assert (alternative_path != null);
                        best_alternative_path = alternative_path;
                        highest_priority = priority;
                    }
                }
            }
        } else {
            critical ("Cannot determine fallback for alternative \"%s\" because path to self could not be determined.", alternative_name);
        }
    } catch (SpawnError e) {
        critical ("Cannot determine fallback for alternative \"%s\" because an error occurred during update-alternatives invocation. The error was: %s", alternative_name, e.message);
    }
    FileUtils.close (stdout_descriptor); //ignores errors
    return best_alternative_path;
}

string? get_executable_for_alternative (string alternative_name) {
    //returns null if fails
    string desired_executable = null;
    if ("www-browser" in alternative_name) {
        const string URI_SCHEME = "http";
        debug ("Looking up the user preference for \"www-browser\" alternative");
        desired_executable = AppInfo.get_default_for_uri_scheme (URI_SCHEME).get_executable ();
        if (desired_executable != null) { debug ("The default executable for URI scheme \"%s\" is \"%s\"", URI_SCHEME, desired_executable ); }
        else {
            warning ("Couldn't determine user-preferred web browser, falling back to system-wide default");
            //TODO: fall back to previous item in alternatives
        }
    } else if ("text-editor" in alternative_name) {
        const string MIMETYPE = "text/plain";
        debug ("Looking up the user preference for \"text-editor\" alternative");
        desired_executable = AppInfo.get_default_for_type (MIMETYPE, false).get_executable ();
        debug ("The default executable for content type \"%s\" is \"%s\"", MIMETYPE, desired_executable );
    } else if (alternative_exists (alternative_name)) {
        critical ("The alternative \"%s\" is not known to me. Contact your distribution maintainers about this issue.", alternative_name);
        Process.exit (1); //TODO: fall back to next item in alternatives system, convert the above to a warning
    } else {
        debug ("\"%s\" is not registered in Debian alternatives system.", alternative_name);
        usage ();
        Process.exit (0);
    }
    return desired_executable;
}

int main (string[] args) {

    Environment.set_prgname ("user-specific-alternatives");
    Granite.Services.Logger.initialize (Environment.get_prgname ());
    Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;
    set_real_path_to_self (args[0]); //TODO: ditch, see beginning of file

    string alternative_name = null;
    try {
        string current_path = args[0];
        while ( true ) {
            current_path = FileUtils.read_link (current_path);
            if ( current_path.has_prefix ("/etc/alternatives") ) {
                alternative_name = Path.get_basename (current_path);
                break;
            }
        }
    } catch (FileError e) {
        alternative_name = Path.get_basename (args[0]);
        warning ("Couldn't get the alternative path by following invocation symlink. Are you sure I'm installed and selected in alternatives sytem?");
    }
    debug ("The name of alternative in question is assumed to be \"%s\"", alternative_name);

    string desired_executable = get_executable_for_alternative (alternative_name);
    string[] executable_with_args = args;
    executable_with_args[0] = desired_executable; //replace our executable path with the one we will launch
    try { Process.spawn_async (null, executable_with_args, null, SpawnFlags.SEARCH_PATH | SpawnFlags.CHILD_INHERITS_STDIN, null, null); }
    catch (SpawnError e) {
        stdout.printf ("Could not launch your preferred application for alternative \"%s\".\nThe error was: %s\n", alternative_name, e.message);
    }

    //debug for fallback functions
//    debug ("The next item in alternatives is \"%s\", will fall back to it in case of failure", get_fallback_alternative(alternative_name));

    return 0;
}
