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
            var scrolled_window = new Gtk.ScrolledWindow () {
                vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
                vscrollbar_policy =  Gtk.PolicyType.AUTOMATIC
            };

            var overlay = new Gtk.Overlay() {
                vexpand = true,
                margin_bottom = 20
            };

            var diary_entries = new Test.VBox(
                _entry_card("asdfs ssssss ssssssssss ssssssss sssssssss sssssssssss sssss sss sssssssss sssss sssss ssssssssssss ssssssssssss sssssssss ssssssssssssss ssssssssss"),
                _entry_card("Lover"),
                _entry_card("Lover"),
                _entry_card("Lover")
                )
            {
                spacing = 20,
                halign = Gtk.Align.FILL,
                valign = Gtk.Align.FILL,
                margins = { 10, 10, 80, 10 },
                css_classes = {"clear_bg"}
            };

            scrolled_window.set_child(diary_entries);

            overlay.add_overlay (new Gtk.Button.from_icon_name("list-add-symbolic") {
                halign = Gtk.Align.END,
                valign = Gtk.Align.END,
                hexpand = true,
                css_classes = {"fill", "circular", "suggested-action", "filter-icon" },
            });
            overlay.set_child (scrolled_window);

            return overlay;
        }

        private Gtk.Box _title_box_mount() {

            var title = new Gtk.Label("Journal") {
                css_classes = { "title-1", "title-bigger" },
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER,
            };

            var filter_button = new Gtk.Button.from_icon_name("view-sort-descending-rtl-symbolic") {
                halign = Gtk.Align.END,
                valign = Gtk.Align.CENTER,
                hexpand = true,
                css_classes = {"flat", "circular", "filter-icon" }
            };

            return new Test.HBox(
                title,
                filter_button
            );
        }

        private Adw.Bin _entry_card(string text) {
            var current_date = new GLib.DateTime.now_local ();
            string date_string = current_date.format("%Y-%m-%d %H:%M:%S");

            var popover_box = new Test.VBox (
                new Gtk.Button.from_icon_name("user-trash-symbolic"),
                new Gtk.Button.from_icon_name("document-edit-symbolic")
            ){ spacing = 6 };

            var status_bar = new Test.HBox (
                 new Gtk.Label(date_string),
                 new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
                    hexpand = true,
                    css_classes = {"spacer"}
                },
                new Gtk.MenuButton() {
                    icon_name = "view-more-horizontal-symbolic",
                    css_classes = {"flat", "circular"},
                    popover = new Gtk.Popover (){ child = popover_box }
                }
            ){
                margins = { 5, 5, 0, 5 },
                halign = Gtk.Align.FILL
            };

            var entry_card = new Test.VBox (
                new Gtk.Picture.for_resource("/com/github/pedromiguel_dev/journaling/img2") { height_request = 190 },
                new Test.VBox (
                    new Gtk.Label ("Title") {
                        css_classes = {"title-1"},
                        halign = Gtk.Align.START
                    },
                    new Gtk.Label (text) {
                        wrap = true,
                        lines = 100,
                        ellipsize = Pango.EllipsizeMode.END,
                        halign = Gtk.Align.START
                    }
                ){
                    margins = { 10, 10, 10, 10 }
                },
                new Gtk.Separator (Gtk.Orientation.HORIZONTAL),
                status_bar
            ){
                spacing = 0,
                margins = { 5, 5, 5, 5 }
            };

            var card = new Adw.Bin() {
                css_classes = {"card", "activatable"},
                overflow = Gtk.Overflow.HIDDEN
            };
            card.set_child(entry_card);
            return card;
        }
    }
}

