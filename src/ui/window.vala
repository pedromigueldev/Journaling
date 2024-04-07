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
    public class MainNavigation : Gtk.Box {

        public Adw.NavigationView Views = new Adw.NavigationView ();

        public MainNavigation () {
            this.set_hexpand (true);
            this.set_vexpand (true);
            _build_ui();
            this.append (Views);

        }

        private void _build_ui () {
            Views.add  (new LockScreen());
            Views.add  (new IncrementCount ());
        }
    }

    public class WellcomeScreen : Adw.NavigationPage {}
    public class LockScreen     : Adw.NavigationPage {
        private Adw.ToolbarView _toolbar = new Adw.ToolbarView ();
        private Adw.HeaderBar _headerBar = new Adw.HeaderBar();
        private Gtk.Button _unlock_button = new Gtk.Button ();
        private Gtk.Box _container = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);

        private bool _isLocked = true;
        public bool isLocked {
            get {
                return _isLocked;
            } private set {
                _isLocked = value;
            }
        }

        public LockScreen  () {
            this.set_title ("Home");

            this._toolbar.add_top_bar (this._headerBar);
            this._toolbar.set_content (_container);
            this.set_child (_toolbar);

            _build_ui();
        }

        private void _build_ui() {
            Gtk.Label title = new Gtk.Label("Journal is Locked");
            Gtk.Label sub_title = new Gtk.Label("Use Password to View Journal.");

            Gtk.Image lock_icon = new Gtk.Image.from_icon_name ("system-lock-screen-symbolic");
            lock_icon.set_pixel_size (32);
            lock_icon.add_css_class ("lock-icon");
            lock_icon.set_halign (Gtk.Align.CENTER);

            title.add_css_class ("title-1");

            _unlock_button.set_child (new Gtk.Label("Unlock"){css_classes = {"accent"}});
            _unlock_button.add_css_class ("pill");
            _unlock_button.add_css_class ("flat");
            this._unlock_button.set_halign (Gtk.Align.CENTER);

            _container.set_hexpand (true);
            _container.set_vexpand (true);
            _container.set_valign (Gtk.Align.CENTER);
            _container.set_halign (Gtk.Align.CENTER);

            _container.append (lock_icon);
            _container.append (title);
            _container.append (sub_title);
            _container.append (_unlock_button);

        }
    }

    public class IncrementCount : Adw.NavigationPage {
        private int _counter = 0;
        public int counter {
            get {
                return _counter;
            } private set {
                _counter = value;
                _label_count.set_label (_counter.to_string ("%i"));
            }
        }

        private Gtk.Label _label_count;
        private Gtk.Button _button_left = new Gtk.Button ();
        private Gtk.Button _button_right = new Gtk.Button ();
        private Gtk.Box _container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);

        public IncrementCount () {
            this.set_title ("Home");
            this._label_count = new Gtk.Label(this.counter.to_string ("%i"));
            this.set_child (_container);
            _build_ui();
        }

        private void _build_ui () {
            _container.set_hexpand (true);
            _container.set_vexpand (true);
            _container.set_valign (Gtk.Align.CENTER);
            _container.set_halign (Gtk.Align.CENTER);

            this._button_left.set_css_classes({"flat", "circular"});
            this._button_left.set_icon_name ("go-previous-symbolic");
            this._button_left.clicked.connect (() => {this.counter--;});

            this._button_right.set_css_classes({"flat", "circular"});
            this._button_right.set_icon_name ("go-next-symbolic");
            this._button_right.clicked.connect (() => {this.counter++;});

            this._label_count.add_css_class ("title-1");

            _container.append (this._button_left);
            _container.append (this._label_count);
            _container.append (this._button_right);
        }
    }

    public class Window : Adw.ApplicationWindow {
        private MainNavigation _main_navigation = new MainNavigation ();

        public Window (Application app) {
            Object (application: app);

            this.application = app;
            this.icon_name = app.application_id;

            //_build_ui();

            var handle = new Gtk.WindowHandle ();
            handle.child = _main_navigation;
            this.content = handle;

            var settings = app.settings;
            settings.bind ("width", this, "default-width", SettingsBindFlags.DEFAULT);
            settings.bind ("height", this, "default-height", SettingsBindFlags.DEFAULT);
        }

        private void _build_ui () {
        }


    }
}
