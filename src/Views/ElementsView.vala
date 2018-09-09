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

        var list_store = new Gtk.ListStore (1, typeof (string));
        list_store.append (out iter);
        list_store.set (iter, 0, "GtkSettings");
        list_store.append (out iter);
        list_store.set (iter, 0, "Inspector");
        list_store.append (out iter);
        list_store.set (iter, 0, "MainWindow");

        var cell = new Gtk.CellRendererText ();

        var elements_tree = new Gtk.TreeView.with_model (list_store);
        elements_tree.headers_visible = false;
        elements_tree.insert_column_with_attributes (-1, "Object", cell, "text", 0);

        var stack = new Gtk.Stack ();
        stack.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
        stack.add_titled (new StylesView (), "styles", "Styles");
        stack.add_titled (new PropertiesView (), "properties", "Properties");
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
        grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        grid.add (stack);

        add1 (elements_tree);
        add2 (grid);
    }
}
