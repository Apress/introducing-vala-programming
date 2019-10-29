
int main( string[] args )
{
    if ( args.length < 2 )
    {
        print( "Usage: %s <module>\n", args[0] );
        return -1;
    }        
    
    var player = new Xmp.Player();
    var valid = player.load_module( args[1] );
    if ( valid < 0 )
    {
        print( "Can't recognize module '%s'\n", args[1] );
        return -1;
    }
    print( "Module %s successfully loaded\n", args[1] );
    
    var ok = player.start();
    if ( ok < 0 )
    {
        print( "Can't start playing\n" );
        return -1;
    }
    
    while ( player.play_frame() == 0 )
    {
        Xmp.FrameInfo info;
        player.get_frame_info( out info );
        if ( info.loop_count > 0 )
        {
            break;
        }
        Posix.write( stdout.fileno(), info.buffer, info.buffer_size );
    }    
    return 0;    
}
