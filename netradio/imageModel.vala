// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

public class ImageModel : Object
{
    public string url { get; private set; }
    public string thumb { get; private set; }

    public ImageModel.fromJsonObject( Json.Object json )
    {
        _url = json.get_string_member( "url" );
        
        var thumb = json.get_object_member( "thumb" );
        _thumb = thumb.get_string_member( "url" );
    }
}
