#!/usr/bin/env vala --pkg=gtk+-3.0

// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

class NetRadio : Gtk.Application
{
    public NetRadio()
    {
        Object( application_id: "de.vanille.valabook.NetRadio" );
    }

    protected override void activate()
    {
        Gtk.ApplicationWindow window = new MainWindow( this, "NetRadio – Streaming Internet Radio!" );
        window.set_border_width( 10 );
        window.set_default_size( 500, 800 );
        window.show_all();
        
        new DBusServer();
    }
}

int main( string[] args )
{
    var app = new NetRadio();
    var returnCode = app.run( args );
    return returnCode;
}
