namespace Journaling {
    public class PageWrapper : Adw.NavigationPage {

        protected Gtk.Orientation orientation;
        protected bool back_button;


        protected Adw.ToolbarView _toolbar = new Adw.ToolbarView();
        protected Adw.HeaderBar _headerBar = new Adw.HeaderBar();
        protected Gtk.Box _container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);

        public PageWrapper (bool back_button = true, Gtk.Orientation orientation, string tag, string title) {
            
            this.set_tag(tag);
            this.set_title(title);

            this._container.orientation = orientation;
            this._headerBar.show_back_button = back_button;

            this._toolbar.add_top_bar(this._headerBar);
            this._toolbar.set_content(this._container);
            this.set_child (this._toolbar);
        }
    }
}