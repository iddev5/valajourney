class AppWindow : Gtk.ApplicationWindow {
    public AppWindow(Gtk.Application app) {
        Object(application: app, title: "Complex application");

        this.window_position = Gtk.WindowPosition.CENTER;
        this.set_default_size(320, 40);

        var button = new Gtk.Button.with_label("Click");
        button.clicked.connect(this.on_button_click);

        this.add(button);
        button.show_all();
    }

    private void on_button_click(Gtk.Button button) {
        var dialog = new Gtk.Dialog.with_buttons(
            "A simple dialog", this, Gtk.DialogFlags.MODAL,
            Gtk.Stock.OK, Gtk.ResponseType.OK, null);

        var content_area = dialog.get_content_area();
        content_area.add(new Gtk.Label("Hello, World!"));

        dialog.response.connect(this.on_dialog_response);
        dialog.show_all();
    }

    private void on_dialog_response(Gtk.Dialog dialog, int response) {
        stdout.printf("response: %d\n", response);
        dialog.destroy();
    }
}


class DialogApp : Gtk.Application {
    public DialogApp() {
        Object(application_id: "org.iddev5.DialogApp");
    }

    protected override void activate() {
        new AppWindow(this).show_all();
    }

}

int main(string[] args) {
    return new DialogApp().run(args);
}
