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

public class StylesView : Gtk.Grid {
    private Gtk.SearchEntry filter_entry;
    private Gtk.CheckButton filter_check;
    private static Gtk.SizeGroup prop_group;
    private static Gtk.SizeGroup prop_value_group;
    private static Gtk.SizeGroup defined_group;

    static construct {
        prop_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
        prop_value_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
        defined_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
    }

    construct {
        filter_entry = new Gtk.SearchEntry ();
        filter_entry.hexpand = true;
        filter_entry.margin = 6;
        filter_entry.placeholder_text = "Filter Properties";

        filter_check = new Gtk.CheckButton.with_label ("Show all");
        filter_check.margin = 6;

        var animation_timing = new PropertyRow ("animation-timing-function", "ease", "");
        var background_clip = new PropertyRow ("background-clip", "padding-box", "gtk-widgets.css: 20.32");
        var background_color = new PropertyRow ("background-color", "rgb(244, 244, 244)", "gtk-widgets.css: 3745.48");
        var background_image = new PropertyRow ("background-image", "linear-gradient(rgb(239,239,239), rgb(230,230,230))", "gtk-widgets.css: 3744.9");
        var background_origin = new PropertyRow ("background-origin", "padding-box", "");

        var listbox = new Gtk.ListBox ();
        listbox.expand = true;
        listbox.set_filter_func (filter_function);
        listbox.add (animation_timing);
        listbox.add (background_clip);
        listbox.add (background_color);
        listbox.add (background_image);
        listbox.add (background_origin);

        attach (filter_entry, 0, 0);
        attach (filter_check, 1, 0);
        attach (listbox, 0, 1, 2, 1);

        filter_check.toggled.connect (() => {
            listbox.invalidate_filter ();
        });

        filter_entry.search_changed.connect (() => {
            listbox.invalidate_filter ();
        });
    }

    [CCode (instance_pos = -1)]
    private bool filter_function (Gtk.ListBoxRow row) {
        if (!filter_check.active && ((PropertyRow) row).defined == "") {
            return false;
        }

        var search_term = filter_entry.text.down ();

        if (search_term in ((PropertyRow) row).property || search_term in ((PropertyRow) row).property_value) {
            return true;
        }
        return false;
    }

    private class PropertyRow : Gtk.ListBoxRow {
        public string property { get; construct; }
        public string property_value { get; construct; }
        public string defined { get; construct; }

        public PropertyRow (string property, string property_value, string defined) {
            Object (
                property: property,
                property_value: property_value,
                defined: defined
            );
        }

        construct {
            var property_label = new Gtk.Label (property);
            property_label.ellipsize = Pango.EllipsizeMode.END;
            property_label.xalign = 0;

            var value_label = new Gtk.Label (property_value);
            value_label.ellipsize = Pango.EllipsizeMode.END;
            value_label.xalign = 0;

            var defined_label = new Gtk.Label (defined);
            defined_label.ellipsize = Pango.EllipsizeMode.END;
            defined_label.xalign = 0;
            defined_label.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

            prop_group.add_widget (property_label);
            prop_value_group.add_widget (value_label);
            defined_group.add_widget (defined_label);

            var grid = new Gtk.Grid ();
            grid.column_spacing = 12;
            grid.margin = 6;
            grid.add (property_label);
            grid.add (value_label);
            grid.add (defined_label);

            add (grid);
        }
    }
}
