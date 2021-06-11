public class TextEditorWindow : Gtk.ApplicationWindow {
    private Gtk.Grid _grid;
    private GLib.File? _file;
    private Gtk.TextBuffer _buffer;
    private string[] _args;

    internal TextEditorWindow(Gtk.Application app, string[] args) {
        GLib.Object(application: app, title: "Text Editor");

        this._args = args;

        this.window_position = Gtk.WindowPosition.CENTER;
        this.set_default_size(800, 600);

        this._grid = new Gtk.Grid();
        this.add(this._grid);

        init_menu();
        init_text();
    }

    private void init_menu() {
        var menubar = new Gtk.MenuBar();

        var file_item = new Gtk.MenuItem.with_label("File");
        file_item.set_submenu(new Gtk.Menu());

        var save_opt = new Gtk.MenuItem.with_label("Save");
        save_opt.activate.connect(this.save_file);
        file_item.submenu.append(save_opt);

        var quit_opt = new Gtk.MenuItem.with_label("Quit");
        quit_opt.activate.connect(this.application.quit);
        file_item.submenu.append(quit_opt);

        menubar.append(file_item);
        this._grid.attach(menubar, 0, 0, 1, 1);
    }

    private void init_text() {
        this._buffer = new Gtk.TextBuffer(null);
        var editor = new Gtk.TextView.with_buffer(this._buffer);
        // editor.set_wrap_mode(Gtk.WrapMode.WORD);

        var scroll_window = new Gtk.ScrolledWindow(null, null);
        scroll_window.set_policy(
            Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scroll_window.add(editor);
        scroll_window.set_hexpand(true);
        scroll_window.set_vexpand(true);

        this._grid.attach(scroll_window, 0, 1, 1, 1);
    }

    private void save_file() {
        var save_dialog = new Gtk.FileChooserDialog(
            "Enter file name", this as Gtk.Window, Gtk.FileChooserAction.SAVE,
            "Cancel", Gtk.ResponseType.CANCEL, "Save", Gtk.ResponseType.ACCEPT);

        save_dialog.set_do_overwrite_confirmation(true);
        save_dialog.set_modal(true);

        if (this._file != null) {
            try {
                (save_dialog as Gtk.FileChooser).set_file(this._file);
            }
            catch (GLib.Error err) {
                stderr.printf("%s\n", err.message);
            }
        }

        save_dialog.response.connect(save_cb);
        save_dialog.show();
    }

    private void save_cb(Gtk.Dialog dialog, int response_id) {
        var save_dialog = dialog as Gtk.FileChooserDialog;

        switch (response_id) {
            case Gtk.ResponseType.ACCEPT:
                this._file = save_dialog.get_file();
                this.save_to_file();
                break;
            default:
                break;
        }

        dialog.destroy();
    }

    private void save_to_file() {
        var buffer = this._buffer;

        Gtk.TextIter start, end;
        buffer.get_bounds(out start, out end);

        var text = buffer.get_text(start, end, false);
        try {
            this._file.replace_contents(text.data, null, false,
                GLib.FileCreateFlags.NONE, null, null);
        }
        catch (GLib.Error err) {
            stderr.printf("%s\n", err.message);
        }
    }
}

public class TextEditor : Gtk.Application {
    private string[] _args;

    internal TextEditor() {
        GLib.Object(application_id: "org.iddev5.TextEditor");
    }

    protected override void activate() {
        new TextEditorWindow(this, this._args).show_all();
    }

    protected override int command_line(GLib.ApplicationCommandLine cliargs) {
        this._args = cliargs.get_arguments();
        return 0;
    }
}

public static int main(string[] args) {
    return new TextEditor().run(args);
}
