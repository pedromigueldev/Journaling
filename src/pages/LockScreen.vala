/* window.vala
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

    public class LockIcon : Vui.Impl.Derived {
        construct {
            derived = new VBox () {
                content = {
                    new Image.from_icon_name ("system-lock-screen-symbolic") {
                        pixel_size = 32,
                        halign = Gtk.Align.CENTER,
                        css_classes = { "lock-icon-image-invert" }
                    }
                },
                css_classes = { "lock-icon" },
                halign = Gtk.Align.CENTER,
                spacing = 10
            };
        }
    }

    public class LockScreen : Vui.Impl.Derived {

        private async void store (string password) {
            bool? is_stored = null;

            try {
                is_stored = yield Journaling.PasswordManager.get_instance ().create_password (password);
            } catch (GLib.Error e) {
                print ("message: %s\n", e.message);
            }

            if (is_stored == null) {
                print ("null password.\n");
                return;
            } else {
                print ("Successfully stored password: %s\n", password);
            }
        }

        private async void password_create (string password_entry) {
            print ("password typed in is %s.\n", password_entry);
            store.begin (password_entry);
        }

        private async void password_look (owned string password_entry, owned bool is_locked) {
            string? password = null;

            try {
                password = yield Journaling.PasswordManager.get_instance ().lookup_password ();
            } catch (GLib.Error e) {
                print ("message: %s\n", e.message);
            }

            if (password_entry == password) {
                print ("Passwords match.\n");
                is_locked = true;
            } else {
                print ("Passwords don't match\n");
                is_locked = false;
            }
        }

        construct {
            var entry_password = "";
            var is_locked = true;

            derived = new ToolBar () {
                title = "Locked",
                top_bar = new HeaderBar (),
                content = new VBox () {
                    spacing = 20,
                    expand = { true, true },
                    valign = Gtk.Align.CENTER,
                    halign = Gtk.Align.CENTER,
                    content = {
                        new LockIcon (),
                        new Label ("Journal is Locked") {
                            css_classes = { "title-1" },
                        },
                        // new Label.ref(() => message.state, message),
                        new Button.with_label ("Unlock") {
                            halign = Gtk.Align.CENTER,
                            css_classes = { "pill", "text-button", "suggested-action" },
                            halign = Gtk.Align.CENTER,
                            on_click = () =>
                                new AlertDialog ("Journal is locked", "") {
                                action_suggested = "Enter",
                                action_destructive = "Cancel",
                                on_response = (res) => this.password_look.begin (entry_password, is_locked),
                                content = new VBox () {
                                    expand = { true, true },
                                    content = {
                                        new LockIcon () {
                                            margin_bottom = 10
                                        },
                                        new Entry ("Type your password") {
                                            string_buffer = (text) => entry_password = text
                                        }
                                    },
                                }
                            }
                        },
                        new Button.with_label ("Create password") {
                            halign = Gtk.Align.CENTER,
                            css_classes = { "pill", "text-button", "suggested-action" },
                            halign = Gtk.Align.CENTER,
                            on_click = () =>
                                new AlertDialog ("Journal is locked", "") {
                                action_suggested = "Enter",
                                action_destructive = "Cancel",
                                // on_response = (res) => password_create.begin(res, entry_password.state),
                                content = new VBox () {
                                    content = {
                                        new LockIcon (),
                                        new HSpacer (),
                                        new Entry ("Type your password")
                                    },
                                    expand = { true, true }
                                }
                            }
                        }
                    }
                }
            };
        }
    }
}
