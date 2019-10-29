// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

class PlayerController : Object
{
    static PlayerController __instance;

    private Gst.Player _player;
    private Gst.PlayerState _state;

    public signal void didUpdateGenres( GenreModel[] genres );
    public signal void didUpdateStations( StationModel[] stations );
    public signal void didUpdatePlayerState();

    public Gst.PlayerState state {
        get {
            return _state;
        }
    }

    public static PlayerController sharedInstance()
    {
        if ( __instance == null )
        {
            __instance = new PlayerController();
        }
        return __instance;
    }

    private PlayerController()
    {
        _player = new Gst.Player( null, null );
        _player.volume = 0.5;
        _player.media_info_updated.connect( onPlayerMediaInfoUpdated );
        _player.state_changed.connect( onPlayerStateChanged );
    }

    //
    // Slots
    //
    public void onPlayerMediaInfoUpdated()
    {
    }

    public void onPlayerStateChanged( Gst.PlayerState state )
    {
        _state = state;
        didUpdatePlayerState();
    }

    //
    // API
    //
    public async void loadPrimaryCategories()
    {
        var genres = yield DirectoryClient.sharedInstance().loadGenres();
        if ( genres != null )
        {
            print( @"Received $(genres.length) genres\n" );
            didUpdateGenres( genres );
        }
        else
        {
            warning( @"Could not get genres" );
        }
    }

    public async void loadStationsForGenre( GenreModel genre )
    {
        var stations = yield DirectoryClient.sharedInstance().loadStations( genre );
        if ( stations != null )
        {
            print( @"Received $(stations.length) stations\n" );
            didUpdateStations( stations );
        }
        else
        {
            warning( @"Could not get stations" );
        }
    }

    public async void playStation( StationModel station )
    {
        var url = yield DirectoryClient.sharedInstance().loadUrlForStation( station );
        _player.stop();
        _player.uri = url;
        print( @"Player URI now $url\n" );
        _player.play();
    }

    public void togglePlayPause()
    {
        switch ( _state )
        {
            case Gst.PlayerState.STOPPED:
                break;

            case Gst.PlayerState.BUFFERING:
                break;

            case Gst.PlayerState.PAUSED:
                _player.play();
                break;

            case Gst.PlayerState.PLAYING:
                _player.pause();
                break;

            default:
                break;
        }
    }

    //
    // Helpers
    //
    public void foo()
    {
            string infoString = "";

        if ( _player != null && _player.media_info != null )
        {
            unowned List<Gst.PlayerAudioInfo> streamList = Gst.Player.get_audio_streams( _player.media_info );
            if ( streamList.length() > 0 )
            {
                print( @"Got $(streamList.length()) streams\n" );
                unowned Gst.PlayerAudioInfo stream = (Gst.PlayerAudioInfo)streamList.data;
                print( "%s\n", stream.get_type().name() );


                print( "%p\n", streamList.data );
                print( "%p\n", stream );

                #if 0
                var title = "";
                if ( stream != null )
                {
                    print( "stream:  %s\n", stream.get_stream_type() );
                }
                else
                {
                    print( "stream is 0\n" );
                }

                var taglist = stream.get_tags();
                if ( taglist != null )
                {
                    print( "kurt" );
                    taglist.@foreach( ( list, tag ) => {
                    print( @"got tag '$tag'\n" );
                    } );
                }
                else
                {
                    print( "no tag list in media_info\n" );
                }
                #endif
            }
        }
    }


}
