#!/usr/bin/env vala

void main()
{    
    var url = "https://api.ipify.org";
    var session = new Soup.Session();
    var message = new Soup.Message( "GET", url );
    session.send_message( message );
    var body = (string) message.response_body.data;
    print( @"My public IP address is '$body'\n" );
}
