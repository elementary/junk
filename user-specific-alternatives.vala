// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-

// $ valac --pkg posix --pkg gio-2.0 --pkg granite app-by-mime.vala

// This code inherits update-alternatives terminology that may be not obvious
// It's recommented to read TERMINOLOGY in "man update-alternatives" before hacking

void usage () {
    stderr.printf ("Usage: you're not supposed to run this directly.

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

string? get_fallback_alternative (string alternative_name) {
    //returns null if fails
    string best_alternative_path = null;
    string self_alternative_path = null;
    int highest_priority = 0;
    debug ("Determining fallback alternative for \"%s\"", alternative_name);
    string[] command = { "update-alternatives", "--query", alternative_name, "--quiet" };
    int stdout_descriptor;
    try {
        Process.spawn_async_with_pipes (null, command, null, SpawnFlags.SEARCH_PATH, null, null, null, out stdout_descriptor, null);
        var stream = FileStream.fdopen (stdout_descriptor, "r");
        assert (stream != null);
        while (! stream.eof ()) {
            string line = stream.read_line ();
            const string self_prefix = "Value: "; //assumption: if this binary got invoked, it's the current value in alternatives system
            const string alternative_prefix = "Alternative: ";
            if (line != null) {
                if (line.has_prefix (self_prefix)) {
                    self_alternative_path = line.substring (self_prefix.length, -1);
                } else if (line.has_prefix (alternative_prefix)) {
                    assert (self_alternative_path != null);
                    string alternative_path;
                    alternative_path = line.substring (alternative_prefix.length, -1);
                    debug ("Found alternative path \"%s\";", alternative_path);
                    int priority;
                    stream.scanf ("Priority: %d", out priority); //never skip this!
                    debug ("its priority is \"%d\".", priority);
                    if ( alternative_path == self_alternative_path ) { debug ("Found self, skipping."); }
                    else if (best_alternative_path == null || priority > highest_priority) {
                        debug ("It's the best alternative path found so far.");
                        assert (alternative_path != null);
                        best_alternative_path = alternative_path;
                        highest_priority = priority;
                    }
                }
            }
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
        debug ("Looking up the user preference for web browser application");
        desired_executable = AppInfo.get_default_for_uri_scheme (URI_SCHEME).get_executable ();
        if (desired_executable != null) { debug ("The default executable for URI scheme \"%s\" is \"%s\"", URI_SCHEME, desired_executable ); }
        else {
            warning ("Couldn't determine user-preferred web browser, falling back to system-wide default");
        }
    } else if ("text-editor" in alternative_name) {
        const string MIMETYPE = "text/plain";
        debug ("Looking up the user preference for text editor application");
        desired_executable = AppInfo.get_default_for_type (MIMETYPE, false).get_executable ();
        debug ("The default executable for content type \"%s\" is \"%s\"", MIMETYPE, desired_executable);
    } else if ("terminal-emulator" in alternative_name) {
        debug ("Looking up the user preference for terminal emulator application");
        string desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");
        debug ("Your desktop environment appears to be \"%s\"", desktop_environment);
        if ( desktop_environment.casefold () == "GNOME".casefold () || desktop_environment.casefold () == "Unity".casefold () || desktop_environment.casefold () == "Pantheon".casefold () ) {
            const string terminal_schema_name = "org.gnome.desktop.default-applications.terminal";
            Settings settings = new Settings (terminal_schema_name);
            desired_executable = settings.get_string ("exec"); //TODO: error handling
        } else if (desktop_environment == null) {
            warning ("Could not determine your desktop environment because XDG_CURRENT_DESKTOP environment variable is not set.");
        } else {
             warning ("I'm not aware of a way to detect the default terminal emulator in your desktop environment \"%s\", sorry.", desktop_environment);
        }
    } else {
        critical ("The alternative \"%s\" is not known to me. Please inform your distribution maintainers about this issue.", alternative_name);
    }
    return desired_executable;
}

int main (string[] args) {

    Granite.Services.Logger.initialize ("user-specific-alternatives");
    Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;

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

    if (! alternative_exists (alternative_name)) {
        debug ("\"%s\" is not registered in Debian alternatives system.", alternative_name);
        usage ();
        Process.exit (Posix.EXIT_SUCCESS);
    } else {
        debug ("The name of alternative in question is assumed to be \"%s\"", alternative_name);
    }

    string? desired_executable = get_executable_for_alternative (alternative_name);
    if (desired_executable == null) {
        desired_executable = get_fallback_alternative (alternative_name);
        if (desired_executable == null) {
            critical ("I've tried everything I know yet failed to determine what to run."); //TODO: elaborate
            Process.exit (Posix.EXIT_FAILURE);
        }
    } else {
        debug ("The desired executable appears to be \"%s\"", desired_executable);
    }

    string[] executable_with_args = args;
    executable_with_args[0] = desired_executable; //replace our executable path with the one we will launch
    try { Process.spawn_async (null, executable_with_args, null, SpawnFlags.SEARCH_PATH | SpawnFlags.CHILD_INHERITS_STDIN, null, null); }
    catch (SpawnError e) {
        critical ("Could not launch your preferred application for alternative \"%s\".\nThe error was: %s\n", alternative_name, e.message);
        Process.exit (Posix.EXIT_FAILURE);
    }

    //debug for fallback functions
//    debug ("The next item in alternatives is \"%s\", will fall back to it in case of failure", get_fallback_alternative(alternative_name));

    return Posix.EXIT_SUCCESS;
}
