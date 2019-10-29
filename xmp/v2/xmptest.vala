
int main( string[] args )
{
    print( "Using XMP version %s (%u)\n", Xmp.version, Xmp.vercode );
    foreach ( var format in Xmp.get_format_list() )
    {
        print( "XMP recognizes format '%s'\n", format );
    }
    return 0;
}        
