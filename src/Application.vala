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

public class Application : Gtk.Application {
    
    /**
     * Load saved notes from disk (if any)
     * TODO Yet to implement this
     */
    private List<StoredNote> loadNotes() {
        var list = new List<StoredNote> ();
        // TODO Load notes from disk (if any)
        return list;
    }
	
    protected override void activate () {
    	var list = loadNotes();
        
        if (list.length() == 0) {
            new StickyNote(this);
        }
	}

	internal Application () {
		Object (application_id: "com.github.niyasc.stickit");
	}
    
    public static int main (string[] args) {
        var app = new Application();
        return app.run();
    }
}
