/*
* Copyright (c) 2018 elementary, Inc. (https://elementary.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

public class MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            title: "Inspector",
            height_request: 700,
            width_request: 1024
        );
    }

    construct {
        var select_object = new Gtk.Button.from_icon_name ("find-location-symbolic");
        select_object.tooltip_markup = "Select an element \n<span size='small' alpha='60%'>Ctrl + Shift + I</span>";

        var stack = new Gtk.Stack ();
        stack.add_titled (new ElementsView (), "objects", "Objects");
        stack.add_titled (new Gtk.Grid (), "stats", "Statistics");
        stack.add_titled (new Gtk.Grid (), "resources", "Resources");
        stack.add_titled (new Gtk.Grid (), "css", "CSS");
        stack.add_titled (new Gtk.Grid (), "visual", "Visual");
        stack.add_titled (new Gtk.Grid (), "general", "General");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.stack = stack;

        var headerbar = new Gtk.HeaderBar ();
        headerbar.custom_title = stack_switcher;
        headerbar.show_close_button = true;
        headerbar.add (select_object);

        set_titlebar (headerbar);
        add (stack);
        show_all ();
    }
}
