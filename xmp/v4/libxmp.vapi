[CCode (cprefix = "XMP_", lower_case_cprefix = "xmp_", cheader_filename = "xmp.h")]
namespace Xmp
{
    [CCode (cname = "xmp_version")]
    public const string version;
    [CCode (cname = "xmp_vercode")]
    public const uint vercode;

    [CCode (array_null_terminated = true)]
    public unowned string[] get_format_list();
    
    [CCode (cname = "struct xmp_test_info", cheader_filename = "xmp.h", destroy_function = "", has_type_id = false)]
    public struct TestInfo
    {
        public string name;
        public string type;
    }
    public static int test_module( string path, out TestInfo info );
    
    [Compact]
    [CCode (cname = "void", cheader_filename = "xmp.h", free_function = "xmp_free_context")]
    public class Player
    {
        [CCode (cname = "xmp_create_context")]
        public Player();

        [CCode (cname = "xmp_load_module")]
        public int load_module( string path );
        [CCode (cname = "xmp_load_module_from_memory")]
        public int load_module_from_memory( uint8[] buffer );
        [CCode (cname = "xmp_load_module_from_file")]
        public int load_module_from_file( Posix.FILE file, long size );
    }
}
