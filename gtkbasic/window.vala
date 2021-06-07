int main(string[] args) {
    Gtk.init(ref args);

    var window = new Gtk.Window();
    window.title = "test window";
    window.window_position = Gtk.WindowPosition.CENTER;
    window.set_default_size(800, 600);

    window.show_all();

    window.destroy.connect(Gtk.main_quit);

    Gtk.main();
    return 0;
}
