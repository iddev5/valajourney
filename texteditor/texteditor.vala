public class TextEditorWindow : Gtk.ApplicationWindow {
    private Gtk.Grid _grid;
    private GLib.File? _file;
    private string _name;
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

        this.new_file();
    }


    private void init_menu() {
        var menubar = new Gtk.MenuBar();

        /* File Menu */
        var file_menu = new Gtk.MenuItem.with_label("File");
        file_menu.set_submenu(new Gtk.Menu());

        var new_opt = new Gtk.MenuItem.with_label("New");
        new_opt.activate.connect(this.new_file);
        file_menu.submenu.append(new_opt);

        var open_opt = new Gtk.MenuItem.with_label("Open File...");
        open_opt.activate.connect(this.open_file);
        file_menu.submenu.append(open_opt);

        file_menu.submenu.append(new Gtk.SeparatorMenuItem());

        var save_opt = new Gtk.MenuItem.with_label("Save");
        save_opt.activate.connect(this.save_file);
        file_menu.submenu.append(save_opt);

        var save_as_opt = new Gtk.MenuItem.with_label("Save As...");
        save_as_opt.activate.connect(this.save_as_file);
        file_menu.submenu.append(save_as_opt);

        file_menu.submenu.append(new Gtk.SeparatorMenuItem());

        var quit_opt = new Gtk.MenuItem.with_label("Quit");
        quit_opt.activate.connect(this.application.quit);
        file_menu.submenu.append(quit_opt);

        menubar.append(file_menu);

        /* Edit menu */
        var edit_menu = new Gtk.MenuItem.with_label("Edit");
        edit_menu.set_submenu(new Gtk.Menu());

        var undo_opt = new Gtk.MenuItem.with_label("Undo");
        undo_opt.activate.connect(() => { /* later */ });
        edit_menu.submenu.append(undo_opt);

        var redo_opt = new Gtk.MenuItem.with_label("Redo");
        redo_opt.activate.connect(() => { /* later */ });
        edit_menu.submenu.append(redo_opt);

        menubar.append(edit_menu);

        this._grid.attach(menubar, 0, 0, 1, 1);
    }

    private void change_title() {
        this.title = (this._name != "" ? this._name : "<unnamed>") +
            (this._buffer.get_modified() ? "*" : "") + " - Text Editor";
    }

    private void init_text() {
        this._buffer = new Gtk.TextBuffer(null);
        this._buffer.set_modified(false);
        this._buffer.changed.connect(on_buf_change);
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


    private void on_buf_change() {
        change_title();
    }

    private void new_file() {
        #if 0
        if (this._buffer.get_modified()) {
            // TODO: Ask whether you want to save or not!
            // Plus this doesnt work as its async
            // Need to do something to make it wait
            save_file();
        }
        #endif

        this._name = "";
        this._file = null;
        this._buffer.set_text("");
        this._buffer.set_modified(false);

        change_title();
    }

    private void open_file() {
        /* (Doesnt work right now)
        if (this._buffer.get_modified()) {
            save_file();
        }
        */

        var open_dialog = new Gtk.FileChooserDialog(
            "Pick a file", this as Gtk.Window, Gtk.FileChooserAction.OPEN,
            "Cancel", Gtk.ResponseType.CANCEL, "Open", Gtk.ResponseType.ACCEPT);

        open_dialog.local_only = false;
        open_dialog.set_modal(true);
        open_dialog.response.connect(this.open_cb);
        open_dialog.show();
    }

    private void open_cb(Gtk.Dialog dialog, int response_id) {
        var open_dialog = dialog as Gtk.FileChooserDialog;

        switch (response_id) {
            case Gtk.ResponseType.ACCEPT:
                this._file = open_dialog.get_file();
                this._name = this._file.get_basename();

                uint8[] file_contents;
                try {
                    this._file.load_contents(null, out file_contents, null);
                }
                catch (GLib.Error err) {
                    stderr.printf("%s\n", err.message);
                }

                this._buffer.set_text((string)file_contents, file_contents.length);
                this._buffer.set_modified(false);
                this.change_title();
                break;
            default:
                break;
        }

        dialog.destroy();
    }

    private void save_file() {
        if (this._name == "") {
            save_as_file();
        }
        else {
            save_to_file();
        }
    }

    private void save_as_file() {
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
        Gtk.TextIter start, end;
        this._buffer.get_bounds(out start, out end);

        var text = this._buffer.get_text(start, end, false);
        try {
            this._file.replace_contents(text.data, null, false,
                GLib.FileCreateFlags.NONE, null, null);
            this._name = this._file.get_basename();
            this._buffer.set_modified(false);
            this.change_title();
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
