#!/usr/bin/env vala

public class Watcher : Object
{
    private int _fd;
    private uint _watch;
    private IOChannel _channel;
    private uint8[] _buffer;

    const uint BUFFER_LENGTH = 4096;

    public Watcher( string path, Linux.InotifyMaskFlags mask )
    {
        _buffer = new uint8[BUFFER_LENGTH];
        
        _fd = Linux.inotify_init();
        if ( _fd == -1 )
        {
            error( @"Can't initialize the inotify subsystem: $(strerror(errno))" );
        }
        
        _channel = new IOChannel.unix_new( _fd );
        _watch = _channel.add_watch( IOCondition.IN | IOCondition.HUP, onActionFromInotify );
        var ok = Linux.inotify_add_watch( _fd, path, mask );
        if ( ok == -1 )
        {
            error( @"Can't watch $path: $(strerror(errno))" );
        }
        print( @"Watching $path...\n" );
    }

    protected bool onActionFromInotify( IOChannel source, IOCondition condition )
    {
        if ( ( condition & IOCondition.HUP ) == IOCondition.HUP )
        {
            error( @"Received HUP from inotify, can't get any more updates" );
            Posix.exit( -1 );
        }
        
        if ( ( condition & IOCondition.IN ) == IOCondition.IN )
        {
            assert( _fd != -1 );
            assert( _buffer != null );
            var bytesRead = Posix.read( _fd, _buffer, BUFFER_LENGTH );
            Linux.InotifyEvent* pevent = (Linux.InotifyEvent*) _buffer;
            handleEvent( *pevent );
        }
        
        return true;
    }

    protected void handleEvent( Linux.InotifyEvent event )
    {
        print( "BOOM!\n" );
        Posix.exit( 0 );
    }

    ~Watcher()
    {
        if ( _watch != 0 )
        {
            Source.remove( _watch );
        }
        
        if ( _fd != -1 )
        {
            Posix.close( _fd );
        }
    }
}

int main( string[] args )
{
    var watcher = new Watcher( "/tmp/foo.txt", Linux.InotifyMaskFlags.ACCESS );
    var loop = new MainLoop();
    loop.run();
    return 0;
}
