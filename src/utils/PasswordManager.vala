/* PasswordManager.vala
 *
 * Copyright 2024 Pedro Miguel
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Journaling {
    public class PasswordManager : GLib.Object {
        private static PasswordManager instance;

        public static PasswordManager get_instance() {
            if (instance == null) {
                instance = new PasswordManager();
            }
            return instance;
        }
        private PasswordManager() {
            attributes["number"] = "8";
            attributes["string"] = "eight";
            attributes["even"] = "true";
        }

        private Secret.Schema password_schema = new Secret.Schema (
             "com.github.pedromiguel_dev.journaling",
             Secret.SchemaFlags.NONE,
             "number", Secret.SchemaAttributeType.INTEGER,
             "string", Secret.SchemaAttributeType.STRING,
             "even", Secret.SchemaAttributeType.BOOLEAN
        );
        private GLib.HashTable<string,string> attributes = new GLib.HashTable<string,string> (null, null);


        public async string? lookup_password() throws Error {
            string? password = yield Secret.password_lookupv (password_schema, attributes, null);
            if (password == null) {
                debug ("Unable to fetch password in libsecret keyring for %s", "com.github.pedromiguel_dev.journaling");
            }
            return password;
        }

        public async bool create_password(string password) throws Error {
            bool? is_stored =  yield Secret.password_storev(password_schema, attributes, Secret.COLLECTION_DEFAULT, "com.github.pedromiguel_dev.journaling", password, null);
            if (is_stored == null) {
                 debug ("Unable to store password for \"%s\" in libsecret keyring", "com.github.pedromiguel_dev.journaling");
            }
            return is_stored;
        }
    }
}
