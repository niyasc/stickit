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
    private string color;
    private int uid;
    private static string[] colors = {"white", "green", "yellow", "orange", "red"};
    private static int uid_counter = 0;
    private static string default_color = "gold";
    private static int font_size = 20;
    
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
        
        var change_color_btn = new Gtk.Button.from_icon_name("open-menu");
        change_color_btn.clicked.connect (change_color);

        Gtk.MenuButton menu_btn = create_menu();

        var header = new Gtk.HeaderBar();
        header.set_title("Stickit");
        header.set_show_close_button (true);
        header.pack_start (new_note_btn);
        header.pack_start (change_color_btn);
        header.pack_start(menu_btn);
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
        
        string style = (".window-%d textview.view text, .window-%d headerbar{background-color: %s;}" +
                        ".window-%d textview.view {font-size: %dpx; font-style : oblique}" +
                        ".window-%d textview.view text{margin : 10px}" +
                        "button {font-weight: bold}")
                        .printf(uid, uid, (this.color == null ? default_color : color), uid, font_size, uid);
        
        css_provider.load_from_data(style);
        
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }
    
    private Gtk.MenuButton create_menu() {
        
		var menubutton = new Gtk.MenuButton();
		menubutton.set_size_request (80, 35);

		var menumodel = new Menu ();
		menumodel.append ("New", "app.new");
		menumodel.append ("About", "win.about");

		/* We create the last item as a MenuItem, so that
		 * a submenu can be appended to this menu item.
		 */
		var submenu = new Menu ();
		menumodel.append_submenu ("Other", submenu);
		submenu.append ("Quit", "app.quit");
		menubutton.set_menu_model (menumodel);

		var about_action = new SimpleAction ("about", null);
		//about_action.activate.connect (this.about_cb);
		this.add_action (about_action);
        
        return menubutton;
    }
    
    private void create_new_note(Gtk.Button new_btn) {
        new StickyNote(this.application);
    }
    
    private void change_color(Gtk.Button change_color) {
        this.color = colors[Random.int_range(0, 5)];
        update_theme();
    }
}
