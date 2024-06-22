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

async void store(string password) {
    bool? is_stored = null;

    try {
        is_stored = yield Journaling.PasswordManager.get_instance().create_password(password);
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

async void password_create(string res, string password_entry) {
    if (res == "cancel") {
        print("Canceled was selected.\n");
        return;
    }
    print("password typed in is %s.\n", password_entry);
    store.begin(password_entry);
}

async void password_look(string res, string password_entry, Vui.Store<bool> tried, Vui.Store<bool> is_locked){
    print("-----%s-----\n", res);
    if (res == "cancel") {
        print("Canceled was selected.\n");
        return;
    }

    string? password = null;

    try {
        password = yield Journaling.PasswordManager.get_instance().lookup_password();
    } catch (GLib.Error e) {
        print("message: %s\n", e.message);
    }

    var pop = Vui.WidgetGeneric.simple_action_group.lookup_action("nav.push.home");

    if (password_entry == password) {
        print("Passwords match.\n");
        is_locked.state = false;
        if (pop != null) {
            pop.activate(null);
        }
         tried.state = false;
    } else {
        print("Passwords don't match\n");
         tried.state = true;
    }
}

Vui.VBox lock_icon() {
    return new Vui.VBox(
        new Vui.Image.from_icon_name("system-lock-screen-symbolic")
            .pixel_size(32)
            .halign(Gtk.Align.CENTER)
            .css_classes({"lock-icon-image-invert"})
    )
    .css_classes({"lock-icon"})
    .halign(Gtk.Align.CENTER)
    .spacing(10);
}


namespace Journaling.Pages {
    using Vui;
    public Page Lock (Vui.Store<bool> is_locked) {
        var message = new Store<string>("Use Password to View Journal.");
        var entry_password = new Store<string>("");
        var tried = new Store<bool>(false);

        tried.changed.connect((tried, state) => {
            if (state == true) {
                print("state is true\n");
                message.state = "Password was wrong";
            }
        });

        return new Page("Locked")
            .child(
                new ToolBar(
                    new HeaderBar()
                        .show_back_button(false)
                        .show_title(false),
                    new VBox(
                        lock_icon(),
                        new Label("Journal is Locked")
                            .css_classes({"title-1"}),
                        new Label.ref(() => message.state, message),
                        new Button(
                            new Label("Unlock")
                            .halign(Gtk.Align.CENTER)
                        )
                        .css_classes({ "pill", "text-button", "suggested-action" })
                        .halign(Gtk.Align.CENTER)
                        .do(() =>
                            new AlertDialog("Journal is locked", "")
                                .add_action("Cancel", Adw.ResponseAppearance.DESTRUCTIVE)
                                .add_action("Verify", Adw.ResponseAppearance.SUGGESTED)
                                .child(
                                    new VBox(
                                        lock_icon().margins(10, 0, 25, 0),
                                        new Spacer(),
                                        new Vui.Entry("Type your password", entry_password)
                                    ).expand(true, true)
                                )
                                .on_response((res) => password_look.begin(res, entry_password.state, tried, is_locked))
                        )
                    )
                    .spacing(20)
                    .expand(true, true)
                    .valign(Gtk.Align.CENTER)
                    .halign(Gtk.Align.CENTER)
                )
            );
        }
}


