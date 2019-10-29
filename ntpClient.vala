#!/usr/bin/env vala --pkg=Posix
struct NtpPacket
{
    uint8 li_vn_mode;      // Eight bits. li, vn, and mode.
                                // li.   Two bits.   Leap indicator.
                                // vn.   Three bits. Version number of the protocol.
                                // mode. Three bits. Client will pick mode 3 for client.

    uint8 stratum;         // Eight bits. Stratum level of the local clock.
    uint8 poll;            // Eight bits. Maximum interval between successive messages.
    uint8 precision;       // Eight bits. Precision of the local clock.

    uint32 rootDelay;      // 32 bits. Total round trip delay time.
    uint32 rootDispersion; // 32 bits. Max error aloud from primary clock source.
    uint32 refId;          // 32 bits. Reference clock identifier.

    uint32 refTm_s;        // 32 bits. Reference time-stamp seconds.
    uint32 refTm_f;        // 32 bits. Reference time-stamp fraction of a second.

    uint32 origTm_s;       // 32 bits. Originate time-stamp seconds.
    uint32 origTm_f;       // 32 bits. Originate time-stamp fraction of a second.

    uint32 rxTm_s;         // 32 bits. Received time-stamp seconds.
    uint32 rxTm_f;         // 32 bits. Received time-stamp fraction of a second.

    uint32 txTm_s;         // 32 bits and the most important field the client cares about. Transmit time-stamp seconds.
    uint32 txTm_f;         // 32 bits. Transmit time-stamp fraction of a second.
}

void main()
{
    const string hostname = "pool.ntp.org";
    const uint16 portno = 123; // NTP
    
    var packet = NtpPacket();
    assert( sizeof( NtpPacket ) == 48 );
    packet.li_vn_mode = 0x1b;

    unowned Posix.HostEnt server = Posix.gethostbyname( hostname ); // Convert URL to IP.
    if ( server == null )
    {
        error( @"Can't resolve host $hostname: $(Posix.errno)" );
    }
    print( @"Found $(server.h_addr_list.length) IP address(es) for $hostname\n" );
    
    var address = Posix.SockAddrIn();
    address.sin_family = Posix.AF_INET;
    address.sin_port = Posix.htons( portno );
    Posix.memcpy( &address.sin_addr, server.h_addr_list[0], server.h_length );
    var stringAddress = Posix.inet_ntoa( address.sin_addr );    
    print( @"Using $hostname IP address $stringAddress\n" );
    
    var sockfd = Posix.socket( Posix.AF_INET, Posix.SOCK_DGRAM, Posix.IPProto.UDP ); // Create a UDP socket.
    if ( sockfd < 0 )
    {
        error( @"Can't create socket: $(Posix.errno)" );
    }
    var ok = Posix.connect( sockfd, address, sizeof( Posix.SockAddrIn ) );
    if ( ok < 0 )
    {
        error( @"Can't connect: $(Posix.errno)" );
    }

    var written = Posix.write( sockfd, &packet, sizeof( NtpPacket ) );
    if ( written < 0 )
    {
        error( "Can't send UDP packet: $(Posix.errno)" );
    }
    
    var received = Posix.read( sockfd, &packet, sizeof( NtpPacket ) );
    if ( received < 0 )
    {
        error( "Can't read from socket: $(Posix.errno)" );
    }
    
    packet.txTm_s = Posix.ntohl( packet.txTm_s ); // Time-stamp seconds.
    packet.txTm_f = Posix.ntohl( packet.txTm_f ); // Time-stamp fraction of a second.
    const uint64 NTP_TIMESTAMP_DELTA = 2208988800ull;
    time_t txTm = ( time_t ) ( packet.txTm_s - NTP_TIMESTAMP_DELTA );
    var str = Posix.ctime( ref txTm );    

    print( @"Current UTC time is $str" );
}

