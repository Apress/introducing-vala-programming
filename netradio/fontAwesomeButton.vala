// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

class FontAwesomeButton : Gtk.Button
{
    private string _icon;
    private uint _size;
    
    public FontAwesomeButton( uint size, string icon )
    {
        Object( label: "dummy" );
        _size = size;
        this.icon = icon;
    }
    
    public string icon
    {
        get
        {
            return _icon;
        }
        set
        {
            var label = (Gtk.Label) get_child();
            var markup = @"<span font_desc=\"FontAwesome $_size\">$value</span>";
            label.set_markup( markup );
        }
    }
}
