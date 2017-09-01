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
    private static string[] colorCode = {"white", "green", "yellow", "orange", "red"};
    private static string[] colorValue = {"ffffff", "9FF780", "F3F781", "FAAC58", "FE642E"};
    private static int uid_counter = 0;
    private static int default_color = 1;
    private static int font_size = 16;
    
    internal StickyNote (Gtk.Application app) {
        
        Object (application: app, title: "Sticky Notes");
        
        this.uid = uid_counter++;
        
        update_theme();

        this.set_default_size(340, 600);
        
        // Container
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
        this.add (box);

        var new_note_btn = new Gtk.Button.from_icon_name("appointment-new-symbolic");
        new_note_btn.clicked.connect (create_new_note);

        Gtk.MenuButton app_menu_btn = create_app_menu();

        var header = new Gtk.HeaderBar();
        header.set_title("Stickit");
        header.set_show_close_button (true);
        header.pack_start (new_note_btn);
        header.pack_start(app_menu_btn);
        this.set_titlebar(header);

        // A ScrolledWindow:
        Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
        box.pack_start (scrolled, true, true, 0);

        // The TextView:
        Gtk.TextView view = new Gtk.TextView ();
        view.set_wrap_mode (Gtk.WrapMode.WORD);
        view.buffer.text = "Lorem Ipsum";
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
            var menu_item = new Gtk.MenuItem.with_label(capitalize(color));
            
            menu_item.activate.connect(change_color_action);
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
    
    private void create_new_note(Gtk.Button new_btn) {
        new StickyNote(this.application);
    }
    
    private void change_color_action(Gtk.MenuItem color_item) {
        this.color = findColorIndex(color_item.get_label());
        update_theme();
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
