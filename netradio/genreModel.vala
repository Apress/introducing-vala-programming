// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

public class GenreModel : Object
{
    public int id { get; private set; }
    public string title { get; private set; }
    public string description { get; private set; }
    public string slug { get; private set; }
    public string ancestry { get; private set; }

    public GenreModel( int id, string title = "", string description = "", string ancestry = "" )
    {
        _id = id;
        _title = title;
        _description = description;
        _ancestry = ancestry;
    }

    public GenreModel.fromJsonObject( Json.Object json )
    {
        _id = (int) json.get_int_member( "id" );
        _title = json.get_string_member( "name" );

        var count = json.get_int_member( "count" );
        _description = @"$count stations in genre";
    }
}
