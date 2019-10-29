#!/usr/bin/env vala --pkg=gio-2.0

void main()
{
    var host = "api.apixu.com";
    var port = 80;
    var key = "f4bddf887be54dc188a111908181801";
    var city = "Neu-Isenburg";
    var query = @"/v1/current.json?key=$key&q=$city";
    var message = @"GET $query HTTP/1.1\r\nHost: $host\r\n\r\n";

    try
    {
        var resolver = Resolver.get_default();
        var addresses = resolver.lookup_by_name( host, null );
        var address = addresses.nth_data( 0 );
        stderr.printf( @"Resolved $host to $address\n" );

        var client = new SocketClient();
        var addr = new InetSocketAddress( address, port );
        var conn = client.connect( addr );
        stderr.printf( @"Connected to $host\n" );

        conn.output_stream.write( message.data );
        stderr.printf( @"Wrote request $message\n" );

        var response = new DataInputStream( conn.input_stream );
        var status_line = response.read_line( null ).strip();
        stderr.printf( @"Got status line: '$status_line'\n" );

        if ( ! ( "200" in status_line ) )
        {
            error( "Service did not answer with 200 OK" );
        }

        var headers = new HashTable<string,string>( str_hash, str_equal );
        var line = "";
        while ( line != "\r" )
        {
            line = response.read_line( null );
            var headerComponents = line.strip().split( ":", 2 );
            if ( headerComponents.length == 2 )
            {
                var header = headerComponents[0].strip();
                var value = headerComponents[1].strip();
                headers[ header ] = value;
                stderr.printf( @"Got Header: $header = $value\n" );
            }
        }
        var contentLength = headers[ "Content-Length" ].to_int();

        var jsonResponse = new uint8[ contentLength ];
        size_t actualLength = 0;
        response.read_all( jsonResponse, out actualLength );
        stderr.printf( @"Got $contentLength bytes of JSON response: %s\n", jsonResponse );
        stdout.printf( @"%s", jsonResponse );

    }
    catch (Error e)
    {
        stderr.printf( @"$(e.message)\n" );
    }
}

