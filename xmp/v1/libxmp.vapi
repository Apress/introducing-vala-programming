[CCode (cprefix = "XMP_", lower_case_cprefix = "xmp_", cheader_filename = "xmp.h")]
namespace Xmp
{
    [CCode (cname = "xmp_version")]
    public const string version;
    [CCode (cname = "xmp_vercode")]
    public const uint vercode;
}
