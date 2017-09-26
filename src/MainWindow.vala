/*-
 * Copyright (c) 2017 elementary LLC. (https://elementary.io)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class SideLoad.MainWindow : Gtk.Dialog {
    public MainWindow () {
        Object (
            deletable: false,
            resizable: false,
            skip_pager_hint: true,
            skip_taskbar_hint: true
        );
    }

    construct {
        var warning_view = new SideLoad.WarningView ();
        var install_view = new SideLoad.InstallView ();

        var stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
        stack.add (warning_view);
        stack.add (install_view);

        get_content_area ().add (stack);

        warning_view.install_clicked.connect (() => stack.visible_child = install_view);
        warning_view.cancel_clicked.connect (() => destroy ());

        install_view.cancel_clicked.connect (() => destroy ());
    }
}
