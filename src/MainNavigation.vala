/* MainNavigation.vala
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
    public class MainNavigation : Gtk.Box {
        private Adw.ApplicationWindow Window;
        public Adw.NavigationView Views = new Adw.NavigationView ();
        public LockScreen lock;

        public MainNavigation (GLib.Settings settings, Adw.ApplicationWindow Window) {
            this.Window = Window;

            _build_ui ();
            this.set_hexpand (true);
            this.set_vexpand (true);
            this.append (Views);
        }

        private void _build_ui () {
            this.lock = new LockScreen (this.Window, this);

            Views.add (new Home ());
            Views.add (new IncrementCount ());
            Views.add (lock);

            Views.push_by_tag ("home");
        }
    }
}
