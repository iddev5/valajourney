public class ExampleTest : Object {
    public void foo() {
        stdout.printf("Foo Foo\n");
    }

    // It doesn't seem to need "public"!
    public static void main(string[] args) {
        var test = new ExampleTest();
        test.foo();
    }
}
