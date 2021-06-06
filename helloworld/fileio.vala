void main(string[] args) {
    try {
        string filename = "file.txt";
        string content = "hello there!";

        // This is a bit crazy!?
        FileUtils.set_contents(filename, content);

        string data;
        FileUtils.get_contents(filename, out data);
        // Looks cool!

        stdout.printf("Data inside: %s\n", data);
    }
    catch (FileError e) {
        stderr.printf("%s\n", e.message); // neat
    }
}
