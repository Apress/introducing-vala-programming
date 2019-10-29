#!/usr/bin/env vala

void main()
{
    var buffer = new uint8[5000];
    var numRead = stdin.read( buffer, 5000 );    
    var jsonString = (string)buffer;
    
    try
    {
        var root = Json.from_string( jsonString );
        var rootObject = root.get_object();
        var currentObject = rootObject.get_object_member( "current" );
        var conditionObject = currentObject.get_object_member( "condition" );
        var conditionText = conditionObject.get_string_member( "text" );
        var feelsLikeC = currentObject.get_double_member( "feelslike_c" );
        var tempC = currentObject.get_double_member( "temp_c" );
        
        print( "Current condition is '%s' with %.1f°C, feeling like %.1f°C\n", conditionText, tempC, feelsLikeC );
    }
    catch ( Error e )
    {
        error( @"$(e.message)" );
    }    
}
