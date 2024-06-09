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
            base(true, "home", "Home",
                new Gtk.Box(Gtk.Orientation.VERTICAL, 10) {
                    hexpand = true,
                    vexpand = true,
                    valign = Gtk.Align.FILL,
                    halign = Gtk.Align.FILL,
                    margin_start = 20,
                    margin_end = 20
                });

            this._headerBar.set_show_title(false);

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

            var diary_entries = new Gtk.Box (Gtk.Orientation.VERTICAL, 15   ) {
                halign = Gtk.Align.FILL,
                valign = Gtk.Align.FILL,
                margin_top = 10,
                margin_start = 10,
                margin_end = 10,
                margin_bottom = 80,
                css_classes = {"clear_bg"}
            };


            diary_entries.append (_entry_card("asdfs ssssss ssssssssss ssssssss sssssssss sssssssssss sssss sss sssssssss sssss sssss ssssssssssss ssssssssssss sssssssss ssssssssssssss ssssssssss"));
            diary_entries.append (_entry_card("Lover"));
            diary_entries.append (_entry_card("Lover"));
            diary_entries.append (_entry_card("Lover"));
            diary_entries.append (_entry_card("Lover"));
            diary_entries.append (_entry_card("Lover"));
            diary_entries.append (_entry_card("Lover"));
            diary_entries.append (_entry_card("Lover"));
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

        private Adw.Bin _entry_card(string text) {
            var card = new Adw.Bin() {
                css_classes = {"card", "activatable"},
                overflow = Gtk.Overflow.HIDDEN
            };
            var entry_card = new Gtk.Box(Gtk.Orientation.VERTICAL, 0) {
                margin_top = 5,
                margin_start = 5,
                margin_bottom = 5,
                margin_end = 5,
            };
            var image = new Gtk.Picture
            .for_resource("/com/github/pedromiguel_dev/journaling/img2") {
                height_request = 190
            };

            var status_bar = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5) {
                margin_start = 5,
                margin_end = 5,
                margin_top = 5,
                halign = Gtk.Align.FILL
            };
            var popover_delete = new Gtk.Button.from_icon_name("user-trash-symbolic");
            var popover_edit = new Gtk.Button.from_icon_name("document-edit-symbolic");
            var popover_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
            popover_box.append(popover_edit);
            popover_box.append(popover_delete);


            var status_bar_button = new Gtk.MenuButton() {
                icon_name = "view-more-horizontal-symbolic",
                css_classes = {"flat", "circular"},
            };
            var pop = new Gtk.Popover();
            pop.set_child(popover_box);
            status_bar_button.set_popover(pop);
            status_bar_button.show();

            var current_date = new GLib.DateTime.now_local ();
            string date_string = current_date.format("%Y-%m-%d %H:%M:%S");

            var status_bar_date = new Gtk.Label(date_string);

            status_bar.append(status_bar_date);
            status_bar.append(
                new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
                    hexpand = true,
                    css_classes = {"spacer"}
                }
            );
            status_bar.append(status_bar_button);


            var content_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10) {
                margin_bottom = 10,
                margin_start = 10,
                margin_end = 10,
                margin_top = 10,
            };
            var title = new Gtk.Label ("Title") {
                css_classes = {"title-1"},
                halign = Gtk.Align.START
            };
            var label = new Gtk.Label (text) {
                wrap = true,
                lines = 100,
                ellipsize = Pango.EllipsizeMode.END,
                halign = Gtk.Align.START
            };

            content_box.append(title);
            content_box.append(label);

            entry_card.append(image);
            entry_card.append(content_box);
            entry_card.append(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));
            entry_card.append(status_bar);

            card.set_child(entry_card);
            return card;
        }
    }
}

