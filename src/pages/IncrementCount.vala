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

namespace Journaling.Pages {

    public Vui.Page IncrementCount () {
        var counter = new Vui.Store<int>(0);

        return new Vui.Page ("Incremment")
        .child (
            new Vui.VBox(
                new Vui.Button.from_icon_name ("go-previous-symbolic")
                    .css_classes ({"flat", "circular"})
                    .do(() => counter.state++),
                new Vui.Label.ref (() =>  counter.state.to_string (), counter)
                    .css_classes ({"title-1"}),
                new Vui.Button.from_icon_name ("go-next-symbolic")
                    .css_classes ({"flat", "circular"})
                    .do(() => counter.state--)
            )
            .spacing(10)
        )
        .expand (true, true)
        .valign (Gtk.Align.CENTER)
        .halign (Gtk.Align.CENTER);
    }
}
