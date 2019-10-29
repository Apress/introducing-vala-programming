
int main( string[] args )
{
    if ( args.length < 2 )
    {
        print( "Usage: %s <module>\n", args[0] );
        return -1;
    }        
    
    Xmp.TestInfo info;
    var valid = Xmp.test_module( args[1], out info );
    
    if ( valid != 0 )
    {
        print( "Can't recognize module '%s'\n", args[1] );
        return -1;
    }
    
    print( "Valid '%s' module: '%s'\n", info.type, info.name );
    
    return 0;    
}
