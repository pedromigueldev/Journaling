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
    using Vui;

    public AppWindow Window (Adw.Application app) {
        var is_locked = new Vui.Store<bool>(true);

        return new AppWindow(app)
            .child (
                new HBox (
                    new Navigation (
                        Journaling.Pages.Lock (is_locked).can_pop(false)
                    )
                    .push_later(
                        Journaling.Pages.IncrementCount(),
                        Journaling.Pages.Home ().can_pop (false)
                    )
                    .on_pushed((nav) => {
                        if(is_locked.state == true) {nav.widget.pop ();}
                    })
                    .add_action("push.home", (nav) => nav.widget.push_by_tag ("Home"))
                    .add_action("print", () => print("this is a action\n"))
                )
                .expand(true, true)
            )
            .save("width", "default-width", SettingsBindFlags.DEFAULT)
            .save ("height", "default-height", GLib.SettingsBindFlags.DEFAULT)
        ;
    }

}
