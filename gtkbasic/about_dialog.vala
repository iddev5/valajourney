//class AppWindow : Gtk.ApWindow

class ComplexApp : Gtk.Application {
    public ComplexApp() {
        GLib.Object(application_id: "org.iddev.ComplexApp");
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this);
        window.title = "test app";
        window.window_position = Gtk.WindowPosition.CENTER;
        window.set_default_size(600, 600);

        window.show_all();

        this.window = window;
    }

    protected override void startup() {
        base.startup();

        var menu = new Menu();
        menu.append("About", "app.about");
        menu.append("Quit", "app.quit");

        this.app_menu = menu;

        var about_action = new SimpleAction("about", null);
        about_action.activate.connect(this.about_cb);
        this.add_action(about_action);

        var quit_action = new SimpleAction("quit", null);
        quit_action.activate.connect(this.quit);
        this.add_action(quit_action);
    }

    private void about_cb(SimpleAction action, Variant? param) {
        Gtk.show_about_dialog(this.window,
            "program-name", "test_app",
            null);
    }

    private unowned Gtk.Window? window;
}

int main(string[] args) {
    var app = new ComplexApp();
    return app.run(args);
}
