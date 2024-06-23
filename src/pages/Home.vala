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

using Vui;
namespace Journaling.Pages {
    public Vui.Page Home () {
        return new Vui.Page ("Home")
            .child(
                new ToolBar(
                    new HeaderBar()
                        .show_back_button(false)
                        .show_title(false),
                    new VBox(
                        _title_box_mount(),
                        _overlay_mount())
                        .spacing(10)
                        .expand(true, true)
                        .valign(Gtk.Align.FILL)
                        .halign(Gtk.Align.FILL)
                        .margins(0, 20, 0, 20))

            );
    }
}

private Overlay _overlay_mount() {
    return new Overlay()
        .set_overlay(
            new Button.from_icon_name("list-add-symbolic")
                .halign(Gtk.Align.END)
                .valign(Gtk.Align.END)
                .margins(0, 0, 20, 0)
                .expand(true, false)
                .css_classes({"fill", "circular", "suggested-action", "filter-icon" })
                .do(() =>
                    new Vui.Dialog ()
                    .title ("New Dialog")
                    .content_size (600, 450)
                    .child (
                        new Vui.ToolBar (
                            new Vui.HeaderBar (),
                            new Vui.VBox (
                                new Vui.Label("TESTE DE LABEL").css_classes ({"title-1"})
                            )
                            .valign(Gtk.Align.CENTER)
                        )
                    )
                )
        )
        .set_child(
            new ScrolledBox (
                new VBox(
                    _entry_card("asdfs ssssss ssssssssss ssssssss sssssssss sssssssssss sssss sss sssssssss sssss sssss ssssssssssss ssssssssssss sssssssss ssssssssssssss ssssssssss"),
                    _entry_card("Lover"),
                    _entry_card("Lover"),
                    _entry_card("Lover")
                )
                .spacing(20)
                .valign(Gtk.Align.FILL)
                .halign(Gtk.Align.FILL)
                .margins(10, 10, 80, 10)
            )
            .hscrollbar_policy(Gtk.PolicyType.NEVER)
            .vscrollbar_policy(Gtk.PolicyType.AUTOMATIC)
        )
        .expand(true, true);
}

private HBox _title_box_mount() {
    return new HBox(
        new Label("Journal")
            .css_classes({"title-1", "title-bigger"})
            .halign(Gtk.Align.START)
            .valign(Gtk.Align.CENTER),

        new Button.from_icon_name("view-sort-descending-rtl-symbolic")
            .halign(Gtk.Align.END)
            .valign(Gtk.Align.CENTER)
            .expand(true, false)
            .css_classes({"flat", "circular", "filter-icon" })
    );
}

private Bin _entry_card(string text) {
    var current_date = new GLib.DateTime.now_local ();
    string date_string = current_date.format("%Y-%m-%d %H:%M:%S");

    var entry_card =
        new VBox (
            new Picture.for_resource("/com/github/pedromiguel_dev/journaling/img2").height_request(190),
            new VBox (
                new Label ("Title")
                    .css_classes({"title-1"})
                    .halign(Gtk.Align.START),
                new Label (text)
                    .expand(true, false)
                    .ellipsize(Pango.EllipsizeMode.END)
                    .halign(Gtk.Align.START)
                    .wrap(true)
                    .lines(100)
            )
            .margins( 10, 10, 10, 10 ),
            new Separator (Gtk.Orientation.HORIZONTAL),
            new HBox ( // status bar
                new Label(date_string),
                new Spacer().expand(true, true),
                new MenuButton (
                    new VBox (
                        new Button.from_icon_name("user-trash-symbolic"),
                        new Button.from_icon_name("document-edit-symbolic")
                    )
                    .spacing(6)
                )
                .icon_name("view-more-horizontal-symbolic")
                .css_classes({"flat", "circular"})
            )
            .margins( 5, 5, 0, 5)
            .halign(Gtk.Align.FILL)
        )
        .spacing(0)
        .margins(5,5,5,5);

    return new Bin(entry_card)
        .css_classes({"card", "activatable"})
        .overflow(Gtk.Overflow.HIDDEN);
}

