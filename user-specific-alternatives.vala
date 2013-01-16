// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-

/* This is a wrapper that allows Debian alternatives system to launch 
 * the application preferred by a specific user instead of a system-wide 
 * and often implicit default, e.g. for "x-www-browser" alternative.
 *
 * This wrapper passes all parameters it receives as well as stdin 
 * to the user-preferred application, so launching it should be equivalent to 
 * launching the user-preferred application directly, except this wrapper 
 * exits as soon as it spawns the target app and DOES NOT wait until it 
 * finishes and returns an exit code.
 *
 * To make this wrapper handle an alternative it already supports, simply
 * register it for that alternative using update-alternatives.
 *
 * Alternative detection is often generalized, e.g. everything containing 
 * "www-browser" is considered to be a GUI text editor. 
 * To avoid "www-browser" launching GUI browser (e.g. firefox) even when
 * a console browser is desired, simply do not install the wrapper
 * for that alternative.
 *
 * To expand the list of supported alternatives you'll have to add a custom
 * handler of that alternative to the code of this wrapper. */

// $ valac --pkg granite --pkg gio-2.0 app-by-mime.vala

int main (string[] args) {

    Granite.Services.Logger.initialize ("user-specific-alternatives");
    Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;

    string self_filename = "";
    self_filename = Path.get_basename (args[0]);
    debug ("Assuming \"%s\" to be the name by which our executable was called", self_filename);

    string desired_executable = "";
    if ("www-browser" in self_filename) {
        debug("Acting upon \"www-browser\" alternative");
        const string URI_SCHEME = "http";
        desired_executable = AppInfo.get_default_for_uri_scheme (URI_SCHEME).get_executable ();
        debug("The default executable for URI scheme \"%s\" is \"%s\"", URI_SCHEME, desired_executable );
    } else if ("text-editor" in self_filename) {
        debug("Acting upon \"text-editor\" alternative");
        const string MIMETYPE = "text/plain";
        desired_executable = AppInfo.get_default_for_type (MIMETYPE, false).get_executable ();
        debug("The default executable for content type \"%s\" is \"%s\"", MIMETYPE, desired_executable );
    } else {
        critical ("The alternative \"%s\" is not known to me. Sorry.", self_filename); //TODO: elaborate, describe direct launch, and convert to a warning
        Process.exit (1); //TODO: fall back to next item in alternatives system
    }

    string[] executable_with_args = args;
    executable_with_args[0] = desired_executable; //replace our executable path with the one we will launch

    Process.spawn_async (null, executable_with_args, null, SpawnFlags.SEARCH_PATH | SpawnFlags.CHILD_INHERITS_STDIN, null, null);

    return 0;
}
