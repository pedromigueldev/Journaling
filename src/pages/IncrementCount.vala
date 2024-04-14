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
    public class IncrementCount : PageWrapper {
        private Gtk.Label _label_count;
        private Gtk.Button _button_left = new Gtk.Button ();
        private Gtk.Button _button_right = new Gtk.Button ();

        private int _counter = 0;
        public int counter {
            get {
                return this._counter;
            } private set {
                this._counter = value;
                this._label_count.set_label (this._counter.to_string ("%i"));
            }
        }

        public IncrementCount () {
            base(true, Gtk.Orientation.HORIZONTAL, "home", "Home");

            this._label_count = new Gtk.Label(this.counter.to_string ("%i"));

            _build_ui();
        }

        private void _build_ui () {
            this._container.set_hexpand (true);
            this._container.set_vexpand (true);
            this._container.set_valign (Gtk.Align.CENTER);
            this._container.set_halign (Gtk.Align.CENTER);

            this._button_left.set_css_classes({"flat", "circular"});
            this._button_left.set_icon_name ("go-previous-symbolic");
            this._button_left.clicked.connect (() => {this.counter--;});

            this._button_right.set_css_classes({"flat", "circular"});
            this._button_right.set_icon_name ("go-next-symbolic");
            this._button_right.clicked.connect (() => {this.counter++;});

            this._label_count.add_css_class ("title-1");

            this._container.append (this._button_left);
            this._container.append (this._label_count);
            this._container.append (this._button_right);
        }
    }
}
