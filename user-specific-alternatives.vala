// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-

// $ valac --pkg granite --pkg gio-2.0 app-by-mime.vala

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

string get_self_real_name (string? alternative_name) {
    //the name of alternative will be used if looking up by procfs fails
    //returns null if fails
    string self_real_name = null;
    //procfs lookups taken from http://stackoverflow.com/questions/1023306/finding-current-executables-path-without-proc-self-exe/
    try { self_real_name = FileUtils.read_link ("/proc/self/exe"); } //Linux
    catch (FileError e) {
        try { self_real_name = FileUtils.read_link ("/proc/curproc/exe"); } //NetBSD
        catch (FileError e) { 
            try { self_real_name = FileUtils.read_link ("/proc/curproc/file"); } //DragonflyBSD
            catch (FileError e) {
                //damn incompatible implementations!
                warning ("Couldn't determine full path to self using procfs. Either procfs is disabled, or a lookup specific to your platform is not yet known to me. Falling back to lookup by Debian alternatives system; the result will be incorrect if this wrapper is not installed for that alternative!");
                //if we got invoked, the relevant alternative should point to us!
                if (alternative_name != null) {
                    if (alternative_exists (alternative_name)) {
                        try { self_real_name = FileUtils.read_link ("/etc/alternatives/" + alternative_name); }
                        catch (FileError e) {
                        critical ("Couldn't determine full path to self neither using procfs nor by alternatives because \"%s\" alternative is misconfigured: either it's a dangling symbolic link, either it's not a symbolic link at all, or I don't have permissions to read it. Please report a bug to your distribution maintainers.", alternative_name);
                        }
                    } else {
                        critical ("Couldn't determine full path to self neither using procfs nor by alternatives because \"%s\" is not registered in Debian alternatives system. I'm not supposed to be invoked this way. Please report a bug to your distribution maintainers.", alternative_name);
                    }
                } else {
                    critical ("Couldn't determine full path to self using procfs and skipping determining it by alternatives system because no alternative name was given. You might want to report a bug to developers of this tool.");
                    //and don't you dare to to loop readlink over args[0] as a fallback!
                }
            }
        }
    }
    return self_real_name;
}

string get_executable_for_alternative (string alternative_name) {
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

    string self_filename = Path.get_basename (args[0]);
    debug ("Assuming the name by which our executable was called, \"%s\", to be the name of alternative we're working with", self_filename);
    string alternative = self_filename;

    string desired_executable = get_executable_for_alternative (alternative);

    string[] executable_with_args = args;
    executable_with_args[0] = desired_executable; //replace our executable path with the one we will launch

    try { Process.spawn_async (null, executable_with_args, null, SpawnFlags.SEARCH_PATH | SpawnFlags.CHILD_INHERITS_STDIN, null, null); }
    catch (SpawnError e) {
        stdout.printf ("Could not launch your preferred application for alternative \"%s\".\nThe error was: %s\n", alternative, e.message);
    }

    return 0;
}
