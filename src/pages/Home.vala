/* Home.vala
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
    public class Home : PageWrapper {
        public Home () {
            base(true, Gtk.Orientation.VERTICAL, "home", "Home");

            this._headerBar.set_show_title(false);
            this._container.set_hexpand(true);
            this._container.set_vexpand(true);
            this._container.set_valign(Gtk.Align.FILL);
            this._container.set_halign(Gtk.Align.FILL);
            this._container.set_spacing(10);
            this._container.set_margin_start(20);
            this._container.set_margin_end(20);

            _build_ui();
        }       
        private void _build_ui() {

            var title_box = _title_box_mount();
            var overlay = _overlay_mount();

            this._container.append(title_box);
            this._container.append(overlay);
        }

        private Gtk.Overlay _overlay_mount() {
            var scrolled_window = new Gtk.ScrolledWindow ();
            scrolled_window.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

            Gtk.Overlay overlay = new Gtk.Overlay() {
                vexpand = true,
                margin_bottom = 20
            };

            Gtk.ListBox diary_entries = new Gtk.ListBox () {
                halign = Gtk.Align.FILL,
                valign = Gtk.Align.START,
                margin_top = 10,
                margin_start = 10,
                margin_end = 10,
                margin_bottom = 60,
                css_classes = {"boxed-list"}
            };

            diary_entries.append (_entry_card("Lover"));

            scrolled_window.set_child(diary_entries);

            overlay.add_overlay (new Gtk.Button.from_icon_name("list-add-symbolic") {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.END,
                hexpand = true,
                css_classes = {"fill", "circular", "suggested-action", "filter-icon" },
            });
            overlay.set_child (scrolled_window);

            return overlay;
        }

        private Gtk.Box _title_box_mount() {
            Gtk.Box title_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            Gtk.Label title = new Gtk.Label("Journal") {
                css_classes = { "title-1", "title-bigger" },
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER,
            };
            Gtk.Button filter_button = new Gtk.Button.from_icon_name("view-sort-descending-rtl-symbolic") {
                halign = Gtk.Align.END,
                valign = Gtk.Align.CENTER,
                hexpand = true,
                css_classes = {"flat", "circular", "filter-icon" }
            };

            title_box.append(title);
            title_box.append(filter_button);

            return title_box;
        }

        private Adw.ActionRow _entry_card(string text) {
            Adw.ActionRow entry_card = new Adw.ActionRow();

            return entry_card;
        }
    }
}

