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
    private Gtk.Application app;
    
    internal StickyNote (Gtk.Application app) {

		Object (application: app, title: "Sticky Notes");

        this.set_default_size(340, 600);
        
        // Container
		var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
		this.add (box);

        var new_btn = new Gtk.Button.with_label("+");
        new_btn.clicked.connect (create_new_note);

        var header = new Gtk.HeaderBar();
        header.set_title("Stickit");
        header.set_show_close_button (true);
        header.pack_start(new_btn);
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
    
    internal void create_new_note(Gtk.Button new_btn) {
        new StickyNote(this.application);
    }
}
