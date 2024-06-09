namespace Journaling {
    public class PageWrapper : Adw.NavigationPage {
        protected bool back_button;


        protected Adw.ToolbarView _toolbar = new Adw.ToolbarView();
        protected Adw.HeaderBar _headerBar = new Adw.HeaderBar();
        protected Gtk.Box _container;

        public PageWrapper (bool back_button = true, string tag, string title, Gtk.Box _container) {
            this.set_tag(tag);
            this.set_title(title);

            this._container = _container;
            this._headerBar.show_back_button = back_button;

            this._toolbar.add_top_bar(this._headerBar);
            this._toolbar.set_content(this._container);
            this.set_child (this._toolbar);
        }
    }
}
