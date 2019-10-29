// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

const string NetRadioBusName = "de.vanille.NetRadio";
const string NetRadioPath = "/";

public class DBusServer : Object, NetRadioDBusInterface
{
    private HashTable<string,StationModel> _knownStations;
    
    public DBusServer()
    {
        Bus.own_name( BusType.SESSION,
                      NetRadioBusName,
                      BusNameOwnerFlags.NONE,
                      onBusAcquired,
                      () => {},
                      () => warning( @"Could not acquire name $NetRadioBusName, the DBus interface will not be available!" )
                     );


        _knownStations = new HashTable<string,StationModel>( str_hash, str_equal );
    }
    
    //
    // HELPERS
    //
    
    void onBusAcquired( DBusConnection conn )
    {
        try
        {
            conn.register_object<NetRadioDBusInterface>( NetRadioPath, this );
        }
        catch ( IOError e )
        {
            error( @"Could not acquire path $NetRadioPath: $(e.message)" );
        }
        print( @"DBus Server is now listening on $NetRadioBusName $NetRadioPath...\n" );
    }
    
    //
    // DBUS API
    //
    public async Item[] listGenres() throws DBusError, IOError
    {
        var genres = yield DirectoryClient.sharedInstance().loadGenres();
        var items = new Item[] {};
        for ( int i = 0; i < genres.length; ++i )
        {
            items += Item() { id = i, name = genres[i].title };
        }
        return items;
    }

    public async Item[] listStations( int id ) throws NetRadioError, DBusError, IOError
    {
        var genre = new GenreModel( id );
        var stations = yield DirectoryClient.sharedInstance().loadStations( genre );
        var items = new Item[] {};
        if ( stations == null )
        {
            throw new NetRadioError.INVALID_GENRE( @"No stations found for genre with id $id" );
        }
        for ( int i = 0; i < stations.length; ++i )
        {
			var station = stations[i];
            var key = @"$id.$i";
            _knownStations[key] = station;
            items += Item() { id = i, name = station.name };
        }
        return items;
    }
    
    public async void playStation( int genre, int station ) throws NetRadioError, DBusError, IOError
    {
        var key = @"$genre.$station";
        var theStation = _knownStations[key];
        if ( theStation != null )
        {
            PlayerController.sharedInstance().playStation( theStation );
        }
        else
        {
            throw new NetRadioError.INVALID_STATION( @"No station found with genre id $genre and station id $station" );
        }
    }
    
    public async void stop() throws DBusError, IOError
    {
        PlayerController.sharedInstance().togglePlayPause();
    }
}
