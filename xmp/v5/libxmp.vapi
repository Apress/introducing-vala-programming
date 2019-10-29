[CCode (cprefix = "XMP_", lower_case_cprefix = "xmp_", cheader_filename = "xmp.h")]
namespace Xmp
{
    [CCode (cprefix = "XMP_FORMAT_")]
    public enum FormatFlags
    {
        8BIT,
        UNSIGNED,
        MONO
    }
    
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
    
    [CCode (cname = "struct xmp_frame_info", cheader_filename = "xmp.h", destroy_function = "", has_type_id = false)]
    public struct FrameInfo
    {
        int pos;
        int pattern;
        int row;
        int num_rows;
        int frame;
        int speed;
        int bpm;
        int time;
        int total_time;
        int frame_time;
        [CCode (array_length = false)]
        uint8[] buffer;
        int buffer_size;
        int total_size;
        int volume;
        int loop_count;
        int virt_channels;
        int virt_used;
        int sequence;
    }

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
    
        [CCode (cname = "xmp_start_player")]
        public int start( int rate = 44100, FormatFlags format = 0 );
        [CCode (cname = "xmp_end_player")]
        public int stop();
        
        [CCode (cname = "xmp_play_frame")]
        public int play_frame();
        [CCode (cname = "xmp_get_frame_info")]
        public int get_frame_info( out FrameInfo info );
    }
}
