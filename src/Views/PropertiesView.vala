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

public class PropertiesView : Gtk.Grid {
    construct {
        Gtk.TreeIter iter;

        var list_store = new Gtk.ListStore (4, typeof (string), typeof (string), typeof (string), typeof (string));
        list_store.append (out iter);
        list_store.set (iter, 0, "app-paintable", 1, "FALSE", 2, "gboolean", 3, "GtkWidget");
        list_store.append (out iter);
        list_store.set (iter, 0, "border-width", 1, "0", 2, "guint", 3, "GtkContainer");
        list_store.append (out iter);
        list_store.set (iter, 0, "can-default", 1, "FALSE", 2, "gboolean", 3, "GtkWidget");
        list_store.append (out iter);
        list_store.set (iter, 0, "can-focus", 1, "FALSE", 2, "gboolean", 3, "GtkWidget");
        list_store.append (out iter);
        list_store.set (iter, 0, "composite-child", 1, "FALSE", 2, "gboolean", 3, "GtkWidget");
        list_store.append (out iter);
        list_store.set (iter, 0, "custom-title", 1, "0x55e9620e27a0", 2, "GtkStackSwitcher", 3, "GtkHeaderBar");

        var cell = new Gtk.CellRendererText ();

        var properties_tree = new Gtk.TreeView.with_model (list_store);
        properties_tree.expand = true;
        properties_tree.insert_column_with_attributes (-1, "Property", cell, "text", 0);
        properties_tree.insert_column_with_attributes (-1, "Value", cell, "text", 1);
        properties_tree.insert_column_with_attributes (-1, "Type", cell, "text", 2);
        properties_tree.insert_column_with_attributes (-1, "Defined At", cell, "text", 3);

        add (properties_tree);
    }
}
