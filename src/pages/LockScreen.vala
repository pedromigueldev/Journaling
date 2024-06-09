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

    public class LockScreen : PageWrapper {

        private PasswordManager password_manager = new PasswordManager();
        private Adw.ApplicationWindow Window;
        private MainNavigation Nav;
        private Gtk.Button _unlock_button = new Gtk.Button();

        private bool _isLocked = true;
        public bool isLocked {
            get {
                return this._isLocked;
            } private set {
                this._isLocked = value;
            }
        }

        public LockScreen(Adw.ApplicationWindow Window, MainNavigation naview) {
            base(true, "locked", "Locked",
                 new Gtk.Box(Gtk.Orientation.VERTICAL, 20));

            this.Window = Window;
            this.Nav = naview;
            this.can_pop = false;

            _build_ui();
        }

        private async void _dialog_verify_password() {
            MessageDialog dialog = new Journaling.MessageDialog(Window, "Type your password for 'Journaling'", _lock_icon());
            string? password = null;

            try {
                password = yield password_manager.lookup_password(dialog.entry.text);
            } catch (GLib.Error e) {
                print("message: %s\n", e.message);
            }

            if (password == null)
                print("Null password.\n");

            dialog.response.connect((response) => {
                if (response == "cancel") {
                    print("Canceled was selected.\n");
                    return;
                }
                print("password typed in is %s.\n", dialog.entry.text);
                if (password != null)
                    print("password is: %s.\n", password);

                if (dialog.entry.text == password) {
                    print("password matches.\n");
                    if (this.Nav.Views.pop())
                        print("removed");
                } else {
                    print("password doesn't match\n");
                }
            });
        }

        private async void _dialog_create_password() {
            MessageDialog dialog = new Journaling.MessageDialog(Window, "Type your password for 'Journaling'", _lock_icon());

            dialog.response.connect(response => {
                if (response == "cancel") {
                    print("Canceled was selected.\n");
                    return;
                }
                print("password typed in is %s.\n", dialog.entry.text);
                store.begin(dialog.entry.text);
            });
        }

        private async void store(string password) {
            bool? is_stored = null;

            try {
                is_stored = yield password_manager.create_password(password);
            } catch (GLib.Error e) {
                print("message: %s\n", e.message);
            }

            if (is_stored == null) {
                print("null password.\n");
                return;
            } else {
                print("Successfully stored password: %s\n", password);
            }
        }

        private void _build_ui() {
            Gtk.Label title = new Gtk.Label("Journal is Locked") {
                css_classes = { "title-1" }
            };
            Gtk.Label sub_title = new Gtk.Label("Use Password to View Journal.");

            var change_pass = new Gtk.Button.with_label("change password");

            this._unlock_button.set_child(
                                          new Gtk.Label("Unlock") {
                css_classes = { "accent" }
            });
            this._unlock_button.set_css_classes({ "pill", "flat" });
            this._unlock_button.set_halign(Gtk.Align.CENTER);
            this._unlock_button.clicked.connect(() => _dialog_verify_password.begin());
            change_pass.clicked.connect(() => _dialog_create_password.begin());

            this._container.set_hexpand(true);
            this._container.set_vexpand(true);
            this._container.set_valign(Gtk.Align.CENTER);
            this._container.set_halign(Gtk.Align.CENTER);

            this._container.append(_lock_icon());
            this._container.append(title);
            this._container.append(sub_title);
            this._container.append(this._unlock_button);
            this._container.append(change_pass);
        }

        private Gtk.Box _lock_icon() {
            Gtk.Box lock_icon_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10) {
                css_classes = { "lock-icon" },
                halign = Gtk.Align.CENTER
            };

            lock_icon_box.append(
                                 new Gtk.Image.from_icon_name("system-lock-screen-symbolic") {
                pixel_size = 32,
                css_classes = { "lock-icon-image-invert" },
                halign = Gtk.Align.CENTER
            });
            return lock_icon_box;
        }
    }
}
