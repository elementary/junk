// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-

// $ valac --pkg granite --pkg gio-2.0 app-by-mime.vala

void usage () {
    stderr.printf ("Usage: you're not supposed to run this.

This is a wrapper that allows Debian alternatives system to launch the application preferred by a specific user instead of a system-wide and often implicit default, e.g. for \"x-www-browser\" alternative. It passes all parameters it receives as well as stdin to the user-preferred application, so launching it should be equivalent to launching the user-preferred application directly, except this wrapper exits as soon as it spawns the target app and DOES NOT wait until it finishes and returns an exit code.

To make this wrapper handle an alternative it already supports, simply register it for that alternative using update-alternatives.
Alternative detection is often generalized, e.g. everything containing \"www-browser\" is considered to be a GUI text editor.
To avoid \"www-browser\" launching GUI browser even when a console browser is desired, simply do not install the wrapper for that alternative.

To expand the list of supported alternatives you'll have to add a custom handler of that alternative to the code of this wrapper.\n");
}

bool is_valid_alternative (string alternative_name) {
    //doesn't do any real validity checks, just checks if it exists
    return FileUtils.test ("/etc/alternatives/" + alternative_name, FileTest.EXISTS);
}

string get_executable_for_alternative (string alternative_name) {
    string desired_executable = "";
    if ("www-browser" in alternative_name) {
        const string URI_SCHEME = "http";
        debug("Looking up the user preference for \"www-browser\" alternative");
        desired_executable = AppInfo.get_default_for_uri_scheme (URI_SCHEME).get_executable ();
        debug("The default executable for URI scheme \"%s\" is \"%s\"", URI_SCHEME, desired_executable );
    } else if ("text-editor" in alternative_name) {
        const string MIMETYPE = "text/plain";
        debug("Looking up the user preference for \"text-editor\" alternative");
        desired_executable = AppInfo.get_default_for_type (MIMETYPE, false).get_executable ();
        debug("The default executable for content type \"%s\" is \"%s\"", MIMETYPE, desired_executable );
    } else if (is_valid_alternative (alternative_name)) {
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

    Granite.Services.Logger.initialize ("user-specific-alternatives");
    Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;

    string self_filename = Path.get_basename (args[0]);
    debug ("Assuming \"%s\" to be the name by which our executable was called", self_filename);

    string desired_executable = get_executable_for_alternative (self_filename);

    string[] executable_with_args = args;
    executable_with_args[0] = desired_executable; //replace our executable path with the one we will launch

    Process.spawn_async (null, executable_with_args, null, SpawnFlags.SEARCH_PATH | SpawnFlags.CHILD_INHERITS_STDIN, null, null);

    return 0;
}
