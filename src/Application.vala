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
    
    private List<StickyNote> current_notes = new List<StickyNote>();
    
    /**
     * Load saved notes from disk (if any)
     * TODO Yet to implement this
     */
    private List<StoredNote> loadNotes() {
        var list = new List<StoredNote> ();
        // TODO Load notes from disk (if any)
        list.append(new StoredNote.from_stored(100, 200, 720, 340, 1, "Hell, World"));
        return list;
    }
	
    protected override void activate () {
    	var list = loadNotes();
        
        if (list.length() == 0) {
            create_note(null);
        } else {
            foreach (StoredNote stored_note in list) {
                create_note(stored_note);
            }
        }
	}
	
	public void create_note(StoredNote? stored = null) {
	    var note = new StickyNote(this, stored);
	    current_notes.append(note);
	}
	
	public void remove_note(StickyNote note) {
	    current_notes.remove(note);
	}

	internal Application () {
		Object (application_id: "com.github.niyasc.stickit");
	}
    
    public static int main (string[] args) {
        var app = new Application();
        return app.run();
    }
}
