[CCode (cprefix = "XMP_", lower_case_cprefix = "xmp_")]
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
}
