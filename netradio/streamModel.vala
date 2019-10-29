// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

public class StreamModel : Object
{
    public int listeners { get; private set; }
    public int status { get; private set; }
    public int bitrate { get; private set; }
    public string content_type { get; private set; }
    public string stream { get; private set; }
    
    public StreamModel.fromJsonObject( Json.Object json )
    {
        _bitrate = (int) json.get_int_member( "bitrate" );
        _listeners = (int) json.get_int_member( "listeners" );
        _status = (int) json.get_int_member( "status" );
        _content_type = json.get_string_member( "content_type" );
        _stream = json.get_string_member( "stream" );
    }
}
