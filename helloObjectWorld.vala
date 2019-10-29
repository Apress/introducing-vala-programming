// helloObjectWorld.vala

class HelloWorld
{
    private string name;

    public HelloWorld( string name )
    {
        this.name = name;
    }

    public void greet()
    {
        var fullGreeting = "Hello " + this.name + "!\n";
        stdout.printf( fullGreeting );
    }    
}

int main( string[] args )
{
    var helloWorldObject = new HelloWorld( args[1] );
    helloWorldObject.greet();
    return 0;
}
