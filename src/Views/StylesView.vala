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
        var style_class_label = new Gtk.Label ("<big>window:dir-ltr.background.csd</big>");
        style_class_label.margin = 6;
        style_class_label.use_markup = true;
        style_class_label.xalign = 0;
        style_class_label.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
        style_class_label.get_style_context ().add_class (Gtk.STYLE_CLASS_MONOSPACE);

        var edit_style_class = new Gtk.MenuButton ();
        edit_style_class.halign = Gtk.Align.END;
        edit_style_class.image = new Gtk.Image.from_icon_name ("edit-symbolic", Gtk.IconSize.MENU);
        edit_style_class.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        var allocation_width = new Gtk.Label (null);
        var allocation_height = new Gtk.Label (null);

        var allocation_grid = new Gtk.Grid ();
        allocation_grid.column_spacing = 3;
        allocation_grid.get_style_context ().add_class ("allocation");
        allocation_grid.add (allocation_width);
        allocation_grid.add (new Gtk.Label ("×"));
        allocation_grid.add (allocation_height);

        var padding_label = new Gtk.Label ("padding");
        var padding_left = new Gtk.Label ("-");
        var padding_right = new Gtk.Label ("-");

        var padding_grid = new Gtk.Grid ();
        padding_grid.get_style_context ().add_class ("padding");
        padding_grid.attach (padding_label, 0, 0);
        padding_grid.attach (new Gtk.Label ("-"), 1, 0);
        padding_grid.attach (padding_left, 0, 1);
        padding_grid.attach (allocation_grid, 1, 1);
        padding_grid.attach (padding_right, 2, 1);
        padding_grid.attach (new Gtk.Label ("-"), 1, 3);

        var border_label = new Gtk.Label ("border");
        var border_left = new Gtk.Label ("-");
        var border_right = new Gtk.Label ("-");

        var border_grid = new Gtk.Grid ();
        border_grid.get_style_context ().add_class ("border");
        border_grid.attach (border_label, 0, 0);
        border_grid.attach (new Gtk.Label ("-"), 1, 0);
        border_grid.attach (border_left, 0, 1);
        border_grid.attach (padding_grid, 1, 1);
        border_grid.attach (border_right, 2, 1);
        border_grid.attach (new Gtk.Label ("-"), 1, 3);

        var margin_label = new Gtk.Label ("margin");
        var margin_left = new Gtk.Label ("-");
        var margin_right = new Gtk.Label ("-");

        var margin_grid = new Gtk.Grid ();
        margin_grid.halign = Gtk.Align.CENTER;
        margin_grid.margin = 12;
        margin_grid.get_style_context ().add_class ("margin");
        margin_grid.attach (margin_label, 0, 0);
        margin_grid.attach (new Gtk.Label ("-"), 1, 0);
        margin_grid.attach (margin_left, 0, 1);
        margin_grid.attach (border_grid, 1, 1);
        margin_grid.attach (margin_right, 2, 1);
        margin_grid.attach (new Gtk.Label ("-"), 1, 3);

        var visualizer_size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
        visualizer_size_group.add_widget (padding_label);
        visualizer_size_group.add_widget (padding_left);
        visualizer_size_group.add_widget (padding_right);
        visualizer_size_group.add_widget (border_label);
        visualizer_size_group.add_widget (border_left);
        visualizer_size_group.add_widget (border_right);
        visualizer_size_group.add_widget (margin_label);
        visualizer_size_group.add_widget (margin_left);
        visualizer_size_group.add_widget (margin_right);

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

        attach (style_class_label, 0, 0);
        attach (edit_style_class, 1, 0);
        attach (margin_grid, 0, 1, 2, 1);
        attach (filter_entry, 0, 2);
        attach (filter_check, 1, 2);
        attach (listbox, 0, 3, 2, 1);

        filter_check.toggled.connect (() => {
            listbox.invalidate_filter ();
        });

        filter_entry.search_changed.connect (() => {
            listbox.invalidate_filter ();
        });

        var style_context = get_style_context ();

        draw.connect (() => {
            allocation_width.label = "%i".printf (get_allocated_width ());
            allocation_height.label = "%i".printf (get_allocated_height ());
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
