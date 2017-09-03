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
    
    private PersistenceManager persistence_manager = new PersistenceManager();
	
    protected override void activate () {
    	var list = persistence_manager.load_from_file();
        
        if (list.size == 0) {
            create_note(null);
        } else {
            foreach (StoredNote stored_note in list) {
                create_note(stored_note);
            }
        }
	}
	
	public void create_note(StoredNote? stored) {
	    var note = new StickyNote(this, stored);
	    current_notes.append(note);
	}
	
	public void remove_note(StickyNote note) {
	    current_notes.remove(note);
	}
	
	public void quit_notes() {
	    List<StoredNote> stored_notes = new List<StoredNote>();
	    
	    foreach (StickyNote sticky_note in current_notes) {
	        stored_notes.append(sticky_note.get_stored_note());
	        sticky_note.close();
	    }
	    
	    persistence_manager.save_notes(stored_notes);
	}

	internal Application () {
		Object (application_id: "com.github.niyasc.stickit");
	}
    
    public static int main (string[] args) {
        var app = new Application();
        return app.run();
    }
}
