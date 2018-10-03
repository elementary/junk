public class Changes : Gtk.Application {
    private Gtk.ApplicationWindow main_window;

    public Changes () {
        Object (application_id: "com.github.danrabbit.lookbook",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        if (get_windows ().length () > 0) {
            get_windows ().data.present ();
            return;
        }

        var infobar = new Gtk.InfoBar ();
        infobar.message_type = Gtk.MessageType.WARNING;
        infobar.get_content_area ().add (new Gtk.Label ("Icons in infobars"));

        var check = new Gtk.CheckButton.with_label ("Redesigned");

        var disabled_check = new Gtk.CheckButton.with_label ("Checkbuttons");
        disabled_check.sensitive = false;

        var active_check = new Gtk.CheckButton.with_label ("with higher contrast");
        active_check.active = true;

        var active_disabled_check = new Gtk.CheckButton.with_label ("between enable states");
        active_disabled_check.active = true;
        active_disabled_check.sensitive = false;

        var scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 1, 0.1);
        scale.draw_value = false;
        scale.set_value (0.7);

        var levelbar = new Gtk.LevelBar.for_interval (0.0, 5.0);
        levelbar.mode = Gtk.LevelBarMode.DISCRETE;
        levelbar.add_offset_value (Gtk.LEVEL_BAR_OFFSET_HIGH, 2);
        levelbar.set_value (2);

        var grid = new Gtk.Grid ();
        grid.column_spacing = 12;
        grid.row_spacing = 12;
        grid.margin = 12;
        grid.attach (check, 0, 1);
        grid.attach (disabled_check, 1, 1);
        grid.attach (active_check, 0, 2);
        grid.attach (active_disabled_check, 1, 2);
        grid.attach (scale, 0, 3, 2, 1);
        grid.attach (levelbar, 0, 4, 2, 1);

        var vgrid = new Gtk.Grid ();
        vgrid.orientation = Gtk.Orientation.VERTICAL;
        vgrid.add (infobar);
        vgrid.add (grid);

        var header = new Gtk.HeaderBar ();
        header.title = "Flatter Titlebar Gradients";
        header.show_close_button = true;

        main_window = new Gtk.ApplicationWindow (this);
        main_window.set_titlebar (header);
        main_window.add (vgrid);
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Changes ();
        return app.run (args);
    }
}
