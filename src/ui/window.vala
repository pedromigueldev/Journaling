/* window.vala
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

    public class Window : Adw.ApplicationWindow {
        private MainNavigation _main_navigation;

        public Window (Application app) {
            Object (application: app);
            var settings = app.settings;

            this.application = app;
            this.icon_name = app.application_id;
            this._main_navigation = new MainNavigation (settings, this);

            _build_ui(settings);
            settings.bind ("width", this, "default-width", SettingsBindFlags.DEFAULT);
            settings.bind ("height", this, "default-height", SettingsBindFlags.DEFAULT);
        }

        private void _build_ui (GLib.Settings settings) {
            var handle = new Gtk.WindowHandle ();
            handle.child = this._main_navigation;
            this.content = handle;
        }


    }
}
