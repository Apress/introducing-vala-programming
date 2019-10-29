// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

public class StationModel : Object
{
    public int id { get; private set; }
    public string name { get; private set; }
    public string description { get; private set; }
    public string logo { get; private set; }

    public StationModel( int id, string name = "", string description = "" )
    {
        _id = id;
        _name = name;
        _description = description;
    }

    public StationModel.fromJsonObject( Json.Object json )
    {
        _id = (int) json.get_int_member( "id" );
        _name = json.get_string_member( "name" );
        _logo = json.get_string_member( "logo" );

        var description = json.has_member( "genre" ) ? json.get_string_member( "genre" ) : "";
        for ( int i = 2; i < 5; ++i )
        {
            var genreMemberName = "genre%d".printf( i );
            if ( json.has_member( genreMemberName ) )
            {
                var genre = json.get_string_member( genreMemberName );
                description += " / %s".printf( genre );
            }
        }
        var bitrate = json.get_int_member( "br" );
        var format = json.get_string_member( "mt" );
        description += @" [$format, $bitrate kbps]";
        _description = description;
    }
}
