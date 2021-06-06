void main() {
    try {
        Process.spawn_command_line_async("ls");

        Process.spawn_command_line_sync("gcc -v");

        int exit_status;
        string std_out, std_err;
        Process.spawn_command_line_sync("cmake --help", out std_out,
            out std_err, out exit_status);
    }
    catch (SpawnError e) {
        stderr.printf("%s\n", e.message);
    }
}
