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

namespace Journaling {
    using Vui.Widget;

    public Vui.Widget.Window Window (Adw.Application app) {
        var is_locked = new Vui.Model.Store<bool> (true);

        return new Vui.Widget.Window (app) {
                   expand = { true, true },
                   content = new Navigation () {
                       expand = { true, true },
                       pages = {
                           new Journaling.Pages.LockScreen (),
                           Journaling.Pages.Home (),
                       }
                   }
        };
    }
}
