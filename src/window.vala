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

    public AppWindow Window (Journaling.Application app) {
        var settings = new GLib.Settings (app.application_id);

        return new AppWindow(app)
            .child (
                new HBox (
                    new Navigation (
                        Journaling.Pages.IncrementCount (),
                        Journaling.Pages.Home (),
                        Journaling.Pages.Lock ()
                    )
                    .add_action("print", () => print("this is a action\n"))
                )
                .expand(true, true)
            )
            .bind((window) => {
                settings.bind ("width", window, "default-width", SettingsBindFlags.DEFAULT);
                settings.bind ("height", window, "default-height", SettingsBindFlags.DEFAULT);
            });
    }

}
