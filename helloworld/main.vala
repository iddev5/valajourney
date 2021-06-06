int main(string[] args) {
    stdout.printf("Hello, World!\n");
    
    foreach (string arg in args) {
        stdout.printf("%s\n", arg);
    }

    string text = stdin.read_line();
    stdout.printf("Input: %s\n", text);
    
    int to_num = int.parse(text);
    stdout.printf("in int: %d\n", to_num);

    // Math.sin isnt working??
    stdout.printf("some op: %f\n", (Math.PI * to_num));

    // a loop
    for (int i = 0; i < 10; i += 1) {
        stdout.printf("%d ", i);
    } 

    return 0;
}
