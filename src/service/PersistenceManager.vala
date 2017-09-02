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

class PersistenceManager {
    private string file_name;
    private string app_dir = Environment.get_home_dir () + "/.local/share/applications/stickit";

    internal PersistenceManager () {
        file_name = this.app_dir + "/saved_notes.json";
    }
    
    public void save_notes(List<StoredNote> notes) {
        string json_string = prepare_json_from_notes(notes);
        
        var file = File.new_for_path (file_name);
        var dir = File.new_for_path(app_dir);
        try {
            if (!dir.query_exists()) {
                dir.make_directory();
            }
        
            var file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION );
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string(json_string);
        } catch (Error e) {
            stderr.printf ("Failed to save notes %s\n", e.message);
        }

    }
    
    private string prepare_json_from_notes (List<StoredNote> notes) {
        string[] json_notes = new string[notes.length()];
        int index = 0;
        foreach (StoredNote note in notes) {
            json_notes[index++] = "{\"x\":%d, \"y\":%d, \"width\":%d, \"height\":%d, \"color\":%d, \"content\":\"%s\"}"
                                    .printf(note.x, note.y, note.width, note.height, note.color, note.content);
        }
        
        return "[%s]".printf(string.joinv(",", json_notes));
    }

    public List<StoredNote> load_from_file() {
        List<StoredNote> stored_notes = new List<StoredNote>();

        try {
            var file = File.new_for_path(file_name);
            var json_string = "";
            if (file.query_exists()) {
                var dis = new DataInputStream (file.read ());
                string line;

                while ((line = dis.read_line (null)) != null) {
                    json_string += line;
                }
                
                var parser = new Json.Parser();
                parser.load_from_data(json_string);
                
                Json.Node root = parser.get_root();
                
                root.get_array().foreach_element((node)=> {
                    int x = int.parse(node.get_string_element(0));
                    int y = int.parse(node.get_string_element(1));
                    int width = int.parse(node.get_string_element(2));
                    int height = int.parse(node.get_string_element(3));
                    int color = int.parse(node.get_string_element(4));
                    string content = node.get_string_element(5);
                    
                    StoredNote stored_note = new StoredNote.from_stored(x, y, width, height, color, content);
                    
                    stored_notes.append(stored_note);
                });
                
            }

        } catch (Error e) {
            stderr.printf ("Failed to load file %s\n", e.message);
        }

        return stored_notes.copy();
    }

}
