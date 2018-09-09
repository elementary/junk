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

public class ElementsView : Gtk.Paned {
    construct {
        Gtk.TreeIter iter;

        var list_store = new Gtk.ListStore (3, typeof (string), typeof (string), typeof (string));
        list_store.append (out iter);
        list_store.set (iter, 0, "Window", 2, "background, csd");

        var cell = new Gtk.CellRendererText ();

        var elements_tree = new Gtk.TreeView.with_model (list_store);
        elements_tree.insert_column_with_attributes (-1, "Name", cell, "text", 0);
        elements_tree.insert_column_with_attributes (-1, "ID", cell, "text", 1);
        elements_tree.insert_column_with_attributes (-1, "Style Classes", cell, "text", 2);

        var stack = new Gtk.Stack ();
        stack.add_titled (new Gtk.Grid (), "computed", "Styles");
        stack.add_titled (new Gtk.Grid (), "properties", "Properties");
        stack.add_titled (new Gtk.Grid (), "signals", "Signals");
        stack.add_titled (new Gtk.Grid (), "other", "Other");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.hexpand = true;
        stack_switcher.margin = 3;
        stack_switcher.stack = stack;

        var grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.add (stack_switcher);
        grid.add (stack);

        add1 (elements_tree);
        add2 (grid);
    }
}
