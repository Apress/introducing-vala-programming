// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

public struct Item
{
    public int id;
    public string name;
}

[DBus (name = "de.vanille.NetRadio")]
public errordomain NetRadioError
{
    [DBus (name = "InvalidGenre")]
    INVALID_GENRE,
    [DBus (name = "InvalidStation")]
    INVALID_STATION
}

[DBus (name = "de.vanille.NetRadio")]
public interface NetRadioDBusInterface : Object
{
    [DBus (name = "ListGenres")]
    public abstract async Item[] listGenres() throws DBusError, IOError;

    [DBus (name = "ListStations")]
    public abstract async Item[] listStations( int id ) throws NetRadioError, DBusError, IOError;

    [DBus (name = "PlayStation")]
    public abstract async void playStation( int genre, int station ) throws NetRadioError, DBusError, IOError;

    [DBus (name = "Stop")]
    public abstract async void stop() throws DBusError, IOError;
}
