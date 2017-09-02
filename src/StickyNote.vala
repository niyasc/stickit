/*
* Copyright (c) 2011-2017 LibreAppFoundation (https://libreappfoundation.github.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Niyas C <niyasmonc@gmail.com>
*/

public class StickyNote : Gtk.ApplicationWindow {
    private int color = -1;
    private int uid;
    private static string[] colorCode = {"white", "green", "yellow", "orange", "red", "blue"};
    private static string[] colorValue = {"ffffff", "9FF780", "F3F781", "FAAC58", "FE642E", " 33f3ff"};
    private static int uid_counter = 0;
    private static int default_color = 1;
    private static int font_size = 16;
    private string content = "";
    
    internal StickyNote (Gtk.Application app, StoredNote? stored = null) {
        
        Object (application: app, title: "Sticky Notes");
        
        if (stored != null) {
            init_from_stored(stored);
        }
        
        this.uid = uid_counter++;
        
        update_theme();

        this.set_default_size(340, 600);
        
        // Container
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
        this.add (box);

        var new_note_btn = new Gtk.Button.from_icon_name("appointment-new-symbolic");
        new_note_btn.clicked.connect (create_new_note);

        var delete_btn = new Gtk.Button.from_icon_name("edittrash");
        delete_btn.clicked.connect(delete_note);

        Gtk.MenuButton app_menu_btn = create_app_menu();

        var header = new Gtk.HeaderBar();
        header.set_title("Stickit");
        header.set_show_close_button (false);
        header.pack_start (new_note_btn);
        header.pack_end(app_menu_btn);
        header.pack_end(delete_btn);
        this.set_titlebar(header);

        // A ScrolledWindow:
        Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
        box.pack_start (scrolled, true, true, 0);

        // The TextView:
        Gtk.TextView view = new Gtk.TextView ();
        view.set_wrap_mode (Gtk.WrapMode.WORD);
        view.buffer.text = this.content;
        scrolled.add (view);
        
        this.show_all();
    }
    
    private void update_theme() {
        var css_provider = new Gtk.CssProvider();
        
        this.get_style_context().add_class("window-%d".printf(uid));
        
        string style = null;
        string selected_color = this.color == -1 ? colorValue[default_color] : colorValue[color];
        if (Gtk.get_minor_version() < 20) {
            style = (".window-%d GtkTextView, .window-%d GtkHeaderBar {background-color: #%s;}" +
                     ".window-%d GtkTextView.view {font-size: %dpx}" +
                     ".window-%d GtkTextView.view text{margin : 10px}")
                     .printf(uid, uid, selected_color, uid, font_size, uid);
       
        } else {
            style = (".window-%d textview.view text, .window-%d headerbar{background-color: #%s;}" +
                     ".window-%d textview.view {font-size: %dpx; font-style : oblique}" +
                     ".window-%d textview.view text{margin : 10px}" +
                     "button {font-weight: bold}")
                     .printf(uid, uid, selected_color, uid, font_size, uid);
        }

        try {
            css_provider.load_from_data(style, -1);
        } catch (GLib.Error e) {
            stdout.printf("Failed to parse css style : %s", e.message);
        }
        
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }
    
    private Gtk.MenuButton create_app_menu() {
        Gtk.Menu change_color_menu = new Gtk.Menu();
        foreach (string color in colorCode) {
            var symbol = new Gtk.Image.from_resource("/com/github/niyasc/stickit/%s.png".printf(color));
            var label = new Gtk.Label(capitalize(color));
            
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
            box.add(symbol);
            box.add(label);

            var menu_item = new Gtk.MenuItem();
            menu_item.action_name = "change_color-" + color;
            menu_item.add(box);
            
            change_color_menu.add(menu_item);
        }
    
        Gtk.MenuItem change_color = new Gtk.MenuItem.with_label("Change Color");
        change_color.set_submenu(change_color_menu);
        
        Gtk.Menu app_menu = new Gtk.Menu();
        app_menu.add(change_color);
        app_menu.show_all();
        
        var app_menu_btn = new Gtk.MenuButton();
        app_menu_btn.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
        app_menu_btn.set_popup(app_menu);
        
        return app_menu_btn;
    }
    
    private void init_from_stored(StoredNote stored) {
        this.color = stored.color;
        this.content = stored.content;
        this.set_default_size (stored.width, stored.height);
        this.move(stored.x, stored.y);
    }
    
    private void create_new_note(Gtk.Button new_btn) {
        ((Application)this.application).create_note(null);
    }
    
    private void change_color_action(Gtk.MenuItem color_item) {
        this.color = findColorIndex(color_item.get_label());
        update_theme();
    }
    
    private void delete_note(Gtk.Button delete_btn) {
        ((Application)this.application).remove_note(this);
        this.close();
    }
    
    private string capitalize(string input) {
        return input.substring(0, 1).up() + input.substring(1).down();
    }
    
    private int findColorIndex(string icolor) {
        int index = 0;
        foreach (string color in colorCode) {
            if (color == icolor.down()) {
                return index;
            }
            index++;
        }
        return -1;
    }
}
