/* Home.vala
 *
 * Copyright 2024-2025 Pedro Miguel
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
using Vui.Widget;

namespace Journaling.Pages {
    public Vui.Widget.ToolBar Home () {
        return new ToolBar () {
                   title = "Home",
                   top_bar = new HeaderBar () {
                       show_back_button = false,
                       show_title = false,
                   },
                   content = new VBox () {
                       spacing = 10,
                       valign = Gtk.Align.FILL,
                       expand = { true, true },
                       margins = { 0, 20, 0, 20 },
                       content = { _title (), _over () },
                   }
        };
    }
}

private HBox _title () {
    return new HBox () {
               content = {
                   new Label ("Journal") {
                       css_classes = { "title-1", "title-bigger" },
                       halign = Gtk.Align.START,
                       valign = Gtk.Align.CENTER,
                   }
               }
    };
}

public Overlay _over () {
    return new Overlay () {
               expand = { true, true },
               content = new ScrolledBox () {
                   content = new VBox () {
                       margins = { 12, 12, 12, 12 },
                       spacing = 20,
                       content = {
                           _entry_card ("asdfs ssssss ssssssssss ssssssss sssssssss sssssssssss sssss sss sssssssss sssss sssss ssssssssssss ssssssssssss sssssssss ssssssssssssss ssssssssss"),
                           _entry_card ("Lover"),
                           _entry_card ("Lover"),
                           _entry_card ("Lover")
                       }
                   }
               },
               overlay = new Button.from_icon_name ("list-add-symbolic") {
                   halign = Gtk.Align.END, valign = Gtk.Align.END,
                   margins = { 0, 0, 20, 0 },
                   expand = { true, false },
                   css_classes = { "fill", "circular", "suggested-action", "filter-icon" },
                   on_click = () => {
                       new Dialog () {
                           title = "new dialog",
                           content_size = { 600, 500 },
                           content = new ToolBar () {
                               top_bar = new HeaderBar (),
                               content = new VBox () {
                                   valign = Gtk.Align.CENTER,
                                   content = {
                                       new Label ("TESTE") {
                                           css_classes = { "title-1" }
                                       }
                                   }
                               }
                           }
                       };
                   }
               }
    };
}

private Bin _entry_card (string text) {
    var current_date = new GLib.DateTime.now_local ();
    string date_string = current_date.format ("%Y-%m-%d %H:%M:%S");

    var entry_card =
        new VBox () {
        content = {
            new Picture.for_resource ("/com/github/pedromiguel_dev/journaling/img2") {
                height_request = 190
            },
            new VBox () {
                content = {
                    new Label ("Title") {
                        css_classes = { "title-1" },
                        halign = Gtk.Align.START,
                    },
                    new Label (text) {
                        ellipsize = Pango.EllipsizeMode.END,
                        halign = Gtk.Align.START,
                        expand = { true, false },
                        wrap = true,
                        lines = 100,
                    }
                },
                margins = { 10, 10, 10, 10 },
            },
            new HSpacer (),
            new HBox () {
                content = {
                    new Label (date_string) {
                        halign = Gtk.Align.START
                    },
                    new MenuButton () {
                        halign = Gtk.Align.END,
                        hexpand = true,
                        content = new VBox () {
                            content = {
                                new Button.from_icon_name ("user-trash-symbolic"),
                                new Button.from_icon_name ("document-edit-symbolic")
                            },
                            spacing = 6
                        },
                        icon_name = "view-more-horizontal-symbolic",
                        css_classes = { "flat", "circular" }
                    }
                },
                margins = { 5, 5, 0, 5 },
                halign = Gtk.Align.FILL
            }
        }
    };
    return new Bin () {
               content = entry_card,
               css_classes = { "card", "activatable" },
               overflow = Gtk.Overflow.HIDDEN,
    };
}
