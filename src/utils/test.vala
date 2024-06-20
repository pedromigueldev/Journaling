namespace Vui {

    [GenericAccessors]
    public interface Widget<T, G>{
        public virtual T spacing (int spacing){return this;}
        public virtual T expand (bool hexpand, bool vexpand){return this;}
        public virtual T valign (Gtk.Align align){return this;}
        public virtual T halign (Gtk.Align align){return this;}
        public virtual T margins (int top, int left, int bottom, int right){return this;}
        public virtual T css_classes (string[] css_classes){return this;}
        public virtual T height_request (int height) {return this;}
    }

    public abstract class WidgetGeneric<T, G> : Widget<T, Gtk.Widget>, GLib.Object  {
        public static SimpleActionGroup simple_action_group = new SimpleActionGroup();

        private G _widget;

        private Gtk.Widget internal_widget {
            get { return (Gtk.Widget) _widget; }
        }

        public G widget {
            get { return _widget; }
            set { _widget = value; }
        }

        public T expand (bool hexpand, bool vexpand) {
            internal_widget.set_hexpand (hexpand);
            internal_widget.set_vexpand (vexpand);
            return this;
        }
        public T valign (Gtk.Align align) {
            internal_widget.set_valign (align);
            return this;
        }
        public T halign (Gtk.Align align){
            internal_widget.set_halign (align);
            return this;
        }

        public T margins (int top, int left, int bottom, int right) {
            internal_widget.margin_top = top;
            internal_widget.margin_end = left;
            internal_widget.margin_bottom = bottom;
            internal_widget.margin_start = right;
            return this;
        }

        public T css_classes (string[] css_classes) {
            internal_widget.set_css_classes (css_classes);
            return this;
        }
    }

    public class Store<T> : GLib.Object {

        private T _state;

        public T state {
            get { return _state; }
            set {
                _state = value;
                state_set();
            }
        }

        public signal void state_set();

        public Store(T initial_state) {
            state = initial_state;
        }
    }

    public class AppWindow : WidgetGeneric<AppWindow, Adw.ApplicationWindow> {

        public AppWindow child (WidgetGeneric<WidgetGeneric, Gtk.Widget> c) {
           widget.set_content (c.widget);
            return this;
        }

        protected delegate void Bind_handler (Adw.ApplicationWindow window);
        public AppWindow bind (Bind_handler handle){
            handle(this.widget);
            return this;
        }

        public AppWindow handle () {
            var handle = new Gtk.WindowHandle ();
            handle.child = this.widget.child;
            widget.set_child (handle);
            return this;
        }

        public AppWindow (Gtk.Application app) {
            widget = new Adw.ApplicationWindow (app);
            widget.icon_name = app.application_id;
        }
    }

    public class Navigation : WidgetGeneric<Navigation, Adw.NavigationView> {
        protected delegate void Action (Adw.NavigationView nav);

        public Navigation bind (Action handle){
            handle(widget);
            return this;
        }

        public Navigation add_action (string action_name, Action handle) {
            var new_action = new SimpleAction("nav." + action_name, null);
            new_action.activate.connect(() => handle(this.widget));

            simple_action_group.add_action(new_action);
            return this;
        }

        public Navigation (params Vui.Page[] c) {
            widget = new Adw.NavigationView ();
            foreach (var item in c){
                widget.add (item.widget);
                this.widget.push (item.widget);

                print("page %s added\n", item.widget.tag);
            }
            this.add_action ("pop", (nav) => nav.pop ());
        }
    }

    public class Page : WidgetGeneric<Page, Adw.NavigationPage> {

        public Page child (WidgetGeneric<WidgetGeneric, Gtk.Widget> c) {
            widget.set_child (c.widget);
            return this;
        }

        public Page (string title) {
           widget = new Adw.NavigationPage (new Gtk.Box (Gtk.Orientation.VERTICAL, 0), title);
           widget.set_tag (title);
        }
    }

    public class ToolBar : WidgetGeneric<ToolBar, Adw.ToolbarView> {

        public ToolBar (WidgetGeneric<WidgetGeneric, Gtk.Widget> top, WidgetGeneric<WidgetGeneric, Gtk.Widget> content,  WidgetGeneric<WidgetGeneric, Gtk.Widget>? bottom_bar = null ) {
            widget = new Adw.ToolbarView ();
            widget.add_top_bar (top.widget);
            widget.set_content (content.widget);
            widget.add_bottom_bar (bottom_bar == null ? new Gtk.Box (Gtk.Orientation.VERTICAL,0) : bottom_bar.widget);
        }
    }

    public class HeaderBar : WidgetGeneric<HeaderBar, Adw.HeaderBar> {
        public HeaderBar show_back_button (bool show_back_button) {
            widget.show_back_button = show_back_button;
            return this;
        }

        public HeaderBar show_title (bool show_title) {
            widget.show_title = show_title;
            return this;
        }

        public HeaderBar () {
            widget = new Adw.HeaderBar ();
        }
    }

    public class Label : WidgetGeneric<Label, Gtk.Label> {

        public Label wrap (bool wrap) {
            widget.set_wrap (wrap);
            return this;
        }
        public Label lines (int lines) {
            widget.set_lines (lines);
            return this;
        }
        public Label ellipsize (Pango.EllipsizeMode mode) {
            widget.set_ellipsize (mode);
            return this;
        }

        protected delegate string String ();

        public Label (String? label = null, Store? state = null) {
            widget = new Gtk.Label (label());
            if(state != null)
                state.state_set.connect (() => {
                   widget.label = label();
                });
        }

    }

    public class Picture : WidgetGeneric<Picture, Gtk.Picture> {

        public Picture height_request (int height) {
            widget.height_request = height;
            return this;
        }

        public Picture () {
          widget = new Gtk.Picture();
        }
        public Picture.for_paintable (Gdk.Paintable? paintable) {
           widget = new Gtk.Picture.for_paintable (paintable);
        }
        public Picture.for_file (GLib.File? file) {
           widget = new Gtk.Picture.for_file (file);
        }
        public Picture.for_resource (string? resource_path) {
           widget = new Gtk.Picture.for_resource (resource_path);
        }
        public Picture.for_filename (string? filename) {
           widget = new Gtk.Picture.for_filename (filename);
        }

    }

    public class Button : WidgetGeneric<Button, Gtk.Button> {
        protected delegate void action<T> ();

        public Button do(owned action actions){
            widget.clicked.connect (() => actions());
            return this;
        }

        construct {
            widget = new Gtk.Button();
        }
        public Button (WidgetGeneric<WidgetGeneric, Gtk.Widget>? child = null) {
            widget.set_child (child.widget);
        }
        public Button.from_icon_name (string icon_name) {
            widget = new Gtk.Button.from_icon_name(icon_name);
        }
        public Button.with_label (string label) {
            widget = new Gtk.Button.with_label (label);
        }
    }

    public class HBox : WidgetGeneric<HBox, Gtk.Box> {
        public HBox spacing (int spacing) {
            widget.set_spacing (spacing);
            return this;
        }

        public HBox (params WidgetGeneric<WidgetGeneric, Gtk.Widget>[]? children) {
            widget = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            if(children != null) {
                foreach (var item in children)
                    widget.append (item.widget);
            }
        }
    }

    public class VBox : WidgetGeneric<VBox, Gtk.Box> {
        public VBox spacing (int spacing) {
            widget.set_spacing (spacing);
            return this;
        }

        public VBox (params WidgetGeneric<WidgetGeneric, Gtk.Widget>[]? children) {
            widget = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            if(children != null) {
                foreach (var item in children)
                    widget.append (item.widget);
            }
        }
    }

    public class Separator : WidgetGeneric<Separator, Gtk.Separator> {
        public Separator(Gtk.Orientation orientation) {
            widget = new Gtk.Separator (orientation);
        }
    }

    public class Spacer : WidgetGeneric<Spacer, Gtk.Separator> {
        public Spacer () {
            widget = new Gtk.Separator (Gtk.Orientation.VERTICAL) { css_classes = {"spacer"} };
        }
    }

    public class MenuButton : WidgetGeneric<MenuButton, Gtk.MenuButton> {

        public MenuButton icon_name (string name){
            widget.set_icon_name (name);
            return this;
        }

        public MenuButton (WidgetGeneric<WidgetGeneric, Gtk.Widget> popover) {
            var ppvr = new Gtk.Popover () { child = popover.widget };
            widget = new Gtk.MenuButton () { popover = ppvr};
        }
    }

    public class AlertDialog : WidgetGeneric<AlertDialog, Adw.AlertDialog> {
        protected delegate void Action (string response);

        public AlertDialog on_response (owned Action action) {
            this.widget.response.connect ((response) => action(response));
            return this;
        }

        public AlertDialog add_action (string action, Adw.ResponseAppearance style) {

            this.widget.add_response (action.ascii_down(), action);
            this.widget.set_response_appearance (action.ascii_down(), style);

            return this;
        }

        public AlertDialog child (WidgetGeneric<WidgetGeneric, Gtk.Widget> c) {
            this.widget.set_extra_child (c.widget);
            return this;
        }

        public AlertDialog (string title, string description) {
            widget = new Adw.AlertDialog (title, description);
            this.widget.present(Journaling.Application.active_window_);
            this.widget.show();
        }
    }

    public class Entry : WidgetGeneric<Entry, Gtk.Entry> {

        public Entry(string placeholder) {
            this.widget = new Gtk.Entry();
            this.widget.set_placeholder_text (placeholder);
        }
    }

    public class Overlay : WidgetGeneric<Overlay, Gtk.Overlay> {
        public Overlay set_overlay (WidgetGeneric<WidgetGeneric, Gtk.Widget> overlay) {
            widget.add_overlay (overlay.widget);
            return this;
        }

        public Overlay set_child (WidgetGeneric<WidgetGeneric, Gtk.Widget> child) {
            widget.child = child.widget;
            return this;
        }

        public Overlay() {
            widget = new Gtk.Overlay ();
        }
    }

    public class ScrolledBox : WidgetGeneric<ScrolledBox, Gtk.ScrolledWindow >  {

        public ScrolledBox vscrollbar_policy (Gtk.PolicyType vscrollbar_policy ) {
            widget.vscrollbar_policy = vscrollbar_policy;
            return this;
        }

        public ScrolledBox hscrollbar_policy (Gtk.PolicyType hscrollbar_policy ) {
            widget.hscrollbar_policy = hscrollbar_policy;
            return this;
        }

        public ScrolledBox (WidgetGeneric<WidgetGeneric, Gtk.Widget> child) {
            widget = new Gtk.ScrolledWindow ();
            widget.set_child (child.widget);
        }
    }

    public class Bin : WidgetGeneric<Bin, Adw.Bin> {

        public Bin overflow (Gtk.Overflow overflow) {
            widget.set_overflow (overflow);
            return this;
        }

        public Bin (WidgetGeneric<WidgetGeneric, Gtk.Widget> child) {
            widget = new Adw.Bin();
            widget.set_child(child.widget);
        }
    }
}

