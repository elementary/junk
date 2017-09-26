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

public class SideLoad.WarningView : Gtk.Grid {
    public signal void cancel_clicked ();
    public signal void install_clicked ();

    construct {
        var image = new Gtk.Image.from_icon_name ("package-x-generic", Gtk.IconSize.DIALOG);
        image.margin_bottom = 1;
        image.margin_end = 3;

        var emblem = new Gtk.Image.from_icon_name ("emblem-downloads", Gtk.IconSize.LARGE_TOOLBAR);
        emblem.valign = Gtk.Align.END;
        emblem.halign = Gtk.Align.END;

        var image_overlay = new Gtk.Overlay ();
        image_overlay.valign = Gtk.Align.START;
        image_overlay.add (image);
        image_overlay.add_overlay (emblem);

        var primary_label = new Gtk.Label (_("This is an application downloaded from the Internet. Are you sure you want to install it?"));
        primary_label.get_style_context ().add_class ("primary");
        primary_label.selectable = true;
        primary_label.max_width_chars = 50;
        primary_label.wrap = true;
        primary_label.xalign = 0;

        var secondary_label = new Gtk.Label (_("Applications downloaded from the Internet may behave strangely or function improperly. This application may not receive security or stability updates."));
        secondary_label.use_markup = true;
        secondary_label.selectable = true;
        secondary_label.max_width_chars = 50;
        secondary_label.wrap = true;
        secondary_label.xalign = 0;

        var cancel_button = new Gtk.Button.with_label (_("Cancel"));

        var install_button = new Gtk.Button.with_label (_("Install"));
        install_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

        var action_area  = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        action_area.margin_top = 18;
        action_area.spacing = 6;
        action_area.set_layout (Gtk.ButtonBoxStyle.END);
        action_area.add (cancel_button);
        action_area.add (install_button);

        column_spacing = 9;
        row_spacing = 6;
        margin_start = margin_end = 10;
        attach (image_overlay, 0, 0, 1, 2);
        attach (primary_label, 1, 0, 1, 1);
        attach (secondary_label, 1, 1, 1, 1);
        attach (action_area, 0, 2, 2, 1);

        cancel_button.clicked.connect (() => {
            cancel_clicked ();
        });

        install_button.clicked.connect (() => {
            install_clicked ();
        });
    }
}
