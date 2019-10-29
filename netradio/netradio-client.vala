// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

MainLoop loop;

public class NetRadioClient : Object
{
    NetRadioDBusInterface netRadioServerProxy;

    public bool init()
    {
        try
        {
            netRadioServerProxy = Bus.get_proxy_sync( BusType.SESSION, "de.vanille.NetRadio", "/" );
        }
        catch ( IOError e )
        {
            print( @"Could not create proxy: $(e.message)\n" );
            return false;
        }
        
        return true;
    }
    
    public async void listGenres()
    {
        try
        {
            var items = yield netRadioServerProxy.listGenres();
            foreach ( var item in items )
            {
                print( "%03d: %s\n", item.id, item.name );
            }
        }
        catch ( Error e )
        {
            print( @"Could not list genres: $(e.message)\n" );
        }
        loop.quit();
    }
    
    public async void listStations( int genre )
    {
        try
        {
            var items = yield netRadioServerProxy.listStations( genre );
            foreach ( var item in items )
            {
                print( "%03d: %s\n", item.id, item.name );
            }
        }
        catch ( Error e )
        {
            print( @"Could not list stations: $(e.message)\n" );
        }
        loop.quit();
    }
    
    public async void playStation( int genre, int station )
    {
        try
        {
            yield netRadioServerProxy.playStation( genre, station );
        }
        catch ( Error e )
        {
            print( @"Could not play station: $(e.message)\n" );
        }            
        loop.quit();
    }
    
    public async void stop()
    {
        try
        {
            yield netRadioServerProxy.stop();
        }
        catch ( Error e )
        {
            print( @"Could not stop: $(e.message)\n" );
        }
        loop.quit();
    }
}

int main( string[] args )
{
    var client = new NetRadioClient();
    if ( !client.init() )
    {
		return -1;
    }
    
    if ( args.length < 2 )
    {
		print( "Usage: %s <command> [param] [param]\n", args[0] );
		return -1;
	}
	
    switch ( args[1] )
    {
        case "lg":
            client.listGenres();
            break;
            
        case "ls":		
            var genre = int.parse( args[2] );
            client.listStations( genre );
            break;
            
        case "play":
            var genre = int.parse( args[2] );
            var station = int.parse( args[3] );
            client.playStation( genre, station );
            break;
            
        case "stop":
            client.stop();
            break;
            
        default:
            print( "Unknown command: %s\n", args[1] );
            break;
    }

    loop = new MainLoop();
    loop.run();

    return 0;
}
