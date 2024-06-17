namespace Journaling {


    public class Page : Adw.NavigationPage {
        protected bool back_button;
        protected Adw.ToolbarView _toolbar = new Adw.ToolbarView();
        protected Adw.HeaderBar _headerBar = new Adw.HeaderBar();
        protected Gtk.Box _container;

        private bool _show_title = true;
        public bool show_title {
            get { return _show_title; }
            set {
                _show_title = value;
                _headerBar.show_title = value;

            }
        }

        public Page (string title, Gtk.Box container) {
            this.set_tag(title.ascii_down());
            this.set_title(title);

            this._container = container;
            this._headerBar.show_back_button = back_button;
            this._toolbar.add_top_bar(this._headerBar);
            this._toolbar.set_content(this._container);
            this.set_child (this._toolbar);
        }
    }
}
