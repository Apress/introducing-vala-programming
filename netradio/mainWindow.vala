// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

class MainWindow : Gtk.ApplicationWindow
{
    private Gtk.Box _box;
    private Gtk.HeaderBar _headerBar;
    private Gtk.Button _backButton;
    private Gtk.ScrolledWindow _scrolledWindow;
    private Gtk.TreeView _treeView;
    private Gtk.ActionBar _actionBar;
    private Gtk.Label _infoLabel;
    private FontAwesomeButton _playButton;
    private PlayerController _controller;

    private GenreModel[]? _genres;
    private GenreModel? _genre;
    private StationModel[]? _stations;
    private StationModel _station;

    private bool initialSelectionHack;

    //
    // Constructor
    //
    public MainWindow( Gtk.Application app, string title )
    {
        Object( application: app, title: title );

        _box = new Gtk.Box( Gtk.Orientation.VERTICAL, 0 );
        _box.homogeneous = false;
        add( _box );

        _headerBar = new Gtk.HeaderBar();
        _box.pack_start( _headerBar, false, false );

        _backButton = new FontAwesomeButton( 18, "&#61523;" );
        _backButton.clicked.connect( onBackButtonClicked );
        _headerBar.pack_start( _backButton );

        _scrolledWindow = new Gtk.ScrolledWindow( null, null );
        _box.pack_start( _scrolledWindow, true, true );
        _treeView = new Gtk.TreeView();
        _scrolledWindow.add( _treeView );

        _treeView.set_grid_lines( Gtk.TreeViewGridLines.HORIZONTAL );
        _treeView.activate_on_single_click = true;
        _treeView.get_selection().changed.connect( onTreeViewSelectionChanged );
		var cell = new Gtk.CellRendererText();
        cell.set_padding( 4, 10 );
		_treeView.insert_column_with_attributes( -1, "Name & Description", cell, "markup", 0 );

        _actionBar = new Gtk.ActionBar();
        _box.pack_start( _actionBar, false, false );

        _infoLabel = new Gtk.Label( "" );
        _actionBar.set_center_widget( _infoLabel );
        _playButton = new FontAwesomeButton( 18, "&#61515;" );
        _playButton.clicked.connect( onPlayButtonClicked );
        _actionBar.pack_end( _playButton );

        _controller = PlayerController.sharedInstance();
        _controller.didUpdateGenres.connect( onControllerDidUpdateGenres );
        _controller.didUpdateStations.connect( onControllerDidUpdateStations );
        _controller.didUpdatePlayerState.connect( onControllerDidUpdatePlayerState );

        _controller.loadPrimaryCategories();
        //_controller.playStation( new StationModel() );
    }

    //
    // Helpers
    //
    private void updateUI()
    {
        updateHeader();
        updateList();
        updateActionBar();
    }

    private void updateHeader()
    {
        if ( _genre != null )
        {
            _headerBar.title = _genre.title;
            _headerBar.subtitle = _genre.description;
            _backButton.sensitive = true;
        }
        else
        {
            _headerBar.title = "All Genres";
            _headerBar.subtitle = null;
            _backButton.sensitive = false;
        }
    }

    private void updateList()
    {
        var listmodel = new Gtk.ListStore( 1, typeof(string) );
		_treeView.set_model( listmodel );

        Gtk.TreeIter iter;

        if ( _stations == null )
        {
            for( int i = 0; i < _genres.length; ++i )
            {
                listmodel.append( out iter );
                var title = markupSanitize( _genres[i].title );
                var subtitle = markupSanitize( _genres[i].description );
                if ( subtitle.length == 0 )
                {
                    subtitle = title;
                }
                var str = "<big><b>%s</b></big>\n\n%s".printf( title, subtitle );
                listmodel.set( iter, 0, str );
            }
        }
        else
        {
            for( int i = 0; i < _stations.length; ++i )
            {
                listmodel.append( out iter );
                var title = markupSanitize( _stations[i].name );
                var subtitle = markupSanitize( _stations[i].description );
                var str = "<big><b>%s</b></big>\n\n%s".printf( title, subtitle );
                listmodel.set( iter, 0, str );
            }
        }
    }

    private void updateActionBar()
    {
        string stateString = "";

        switch ( _controller.state )
        {
            case Gst.PlayerState.STOPPED:
                stateString = "STOPPED";
                _playButton.icon = "";
                _playButton.set_sensitive( false );
                break;

            case Gst.PlayerState.BUFFERING:
                stateString = "BUFFERING...";
                _playButton.icon = "&#61712;";
                _playButton.set_sensitive( false );
                break;

            case Gst.PlayerState.PAUSED:
                stateString = "PAUSED";
                _playButton.icon = "&#61515;";
                _playButton.set_sensitive( true );
                break;

            case Gst.PlayerState.PLAYING:
                stateString = "PLAYING";
                _playButton.icon = "&#61516;";
                _playButton.set_sensitive( true );
                break;
        }

        var str = @"$stateString";
        _infoLabel.set_markup( str );
    }

    private string markupSanitize( string text )
    {
        return text; //text.replace( "&", "&amp;" );
    }

    //
    // Slots
    //

    private void onControllerDidUpdateGenres( GenreModel[] genres )
    {
        _genres = genres;
        _stations = null;
        updateUI();
    }

    private void onControllerDidUpdateStations( StationModel[] stations )
    {
        _stations = stations;
        updateUI();
    }

    private void onControllerDidUpdatePlayerState()
    {
        updateActionBar();
    }

    private void onTreeViewSelectionChanged()
    {
        Gtk.TreeModel model;
        var paths = _treeView.get_selection().get_selected_rows( out model );
        if ( paths.length() == 0 )
        {
            return;
        }
        if ( !initialSelectionHack )
        {
            _treeView.get_selection().unselect_all();
            initialSelectionHack = true;
            print( "selection hack done\n" );
            return;
        }
        Gtk.TreePath path = paths.first().data;
        int[] indices = path.get_indices();
        var rowIndex = indices[0];

        if ( _genre == null )
        {
            _genre = _genres[rowIndex];
            _controller.loadStationsForGenre( _genre );
        }
        else // stations are in
        {
            _station = _stations[rowIndex];
            _controller.playStation( _station );
        }
    }

    private void onBackButtonClicked()
    {
        _genre = null;
        _stations = null;
        updateUI();
    }

    private void onPlayButtonClicked()
    {
        _controller.togglePlayPause();
    }

    private void onPlayerStateChanged()
    {
        updateActionBar();
    }
}
