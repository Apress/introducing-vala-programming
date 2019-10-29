// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

const string PrefixURL = "https://wellenreiter.vanille.de/netradio";
const string GetPrimaryCategoriesURL = PrefixURL + "/genres";
const string GetStationsForGenreURL = PrefixURL + "/genres/%u";
const string GetStationURL = PrefixURL + "/stations/%u";

public delegate void StringCompletionHandler( uint statusCode, Json.Node rootNode );

public class DirectoryClient : Object
{
    private Soup.Session _session;
    private static DirectoryClient __instance;

    private DirectoryClient()
    {
        _session = new Soup.Session();
    }

    //
    // API
    //
    public static DirectoryClient sharedInstance()
    {
        if ( __instance == null )
        {
            __instance = new DirectoryClient();
        }

        return __instance;
    }

    public async GenreModel[]? loadGenres()
    {
        GenreModel[] result = null;

        var url = GetPrimaryCategoriesURL;
        loadJsonForURL( url, ( statusCode, rootNode ) => {

            if ( statusCode == 200 )
            {
                var genres = new GenreModel[] {};
                var array = rootNode.get_array();
                for ( uint i = 0; i < array.get_length(); ++i )
                {
                    var object = array.get_object_element( i );
                    var genre = new GenreModel.fromJsonObject( object );
                    genres += genre;
                }
                result = genres;
            }
        } );

        return result;
    }

    public async StationModel[]? loadStations( GenreModel genre )
    {
        StationModel[] result = null;

        var url = GetStationsForGenreURL.printf( genre.id );
        loadJsonForURL( url, ( statusCode, rootNode ) => {

            if ( statusCode == 200 )
            {
                var stations = new StationModel[] {};
                var array = rootNode.get_array();
                for ( uint i = 0; i < array.get_length(); ++i )
                {
                    var object = array.get_object_element( i );
                    var station = new StationModel.fromJsonObject( object );
                    stations += station;
                }
                result = stations;
            }

        } );

        return result;
    }

    public async string? loadUrlForStation( StationModel station )
    {
        string result = null;
        var url = GetStationURL.printf( station.id );
        loadJsonForURL( url, ( statusCode, rootNode ) => {

            if ( statusCode == 200 )
            {
                var object = rootNode.get_object();
                result = object.get_string_member( "url" );
            }

        } );

        return result;
    }

    //
    // Helpers
    //
    public void loadJsonForURL( string url, StringCompletionHandler block )
    {
        var message = new Soup.Message( "GET", url );
        assert( message != null );
#if 0 // ASYNC API BROKEN
        _session.queue_message( message, ( session, msg ) => {
            print( "GET %s => %u\n%s\n", url, msg.status_code, (string) msg.response_body.data );
            var rootnode = Json.from_string( (string) msg.response_body.data );
            block( msg.status_code, rootnode  );
        } );
#else
        _session.send_message( message );
        print( "GET %s => %u\n%s\n", url, message.status_code, (string) message.response_body.data );
        var rootnode = Json.from_string( (string) message.response_body.data );
        block( message.status_code, rootnode  );
#endif
    }

}

