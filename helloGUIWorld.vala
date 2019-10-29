int main( string[] args )
{
    Gtk.init( ref args );

    var window = new Gtk.Window();
    window.title = "Hello UI World";

    window.border_width = 10;
    window.window_position = Gtk.WindowPosition.CENTER;
    window.set_default_size( 400, 150 );
    window.destroy.connect( Gtk.main_quit );

    var button = new Gtk.Button.with_label( "Click me!" );
    button.clicked.connect( () => {
        button.label = "Thank you!";
    } );

    window.add( button );
    window.show_all();

    Gtk.main();
    return 0;
}
