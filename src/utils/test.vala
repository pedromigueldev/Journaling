namespace VuiDepr {

    [GenericAccessors]
    protected interface Widget<T>{
        public abstract T expand (bool hexpand, bool vexpand);
        public abstract T valign (Gtk.Align align);
        public abstract T halign (Gtk.Align align);
        public abstract T margins (int top, int left, int bottom, int right);
        public abstract T css_classes (string[] css_classes);
        public abstract T height_request (int height);
        public abstract T save (string key, string property, GLib.SettingsBindFlags flag);
    }

    public abstract class WidgetGeneric<T, G> : Widget<T>, GLib.Object  {
        public static SimpleActionGroup simple_action_group = new SimpleActionGroup();
        public static GLib.Settings gsettings;

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
            foreach(var item in css_classes){
                internal_widget.add_css_class (item);
            }
            return this;
        }

        public T height_request (int height) {
            internal_widget.height_request = height;
            return this;
        }

        public T save (string key, string property, GLib.SettingsBindFlags flag) {
            WidgetGeneric.gsettings.bind (key, this.internal_widget, property, flag);
            return this;
        }
    }

    public class Store<T> : GLib.Object {

        private T _state;

        public T state {
            get { return _state; }
            set {
                _state = value;
                changed(value);
            }
        }

        public signal void changed(T state);

        public Store(T initial_state) {
            state = initial_state;
        }
    }

    public class App : Adw.Application {
        public static Gtk.Window _active_window_;
    }

    public class AppWindow : WidgetGeneric<AppWindow, Adw.ApplicationWindow> {

        public AppWindow child (WidgetGeneric<WidgetGeneric, Gtk.Widget> c) {
           widget.set_content (c.widget);
            return this;
        }

        protected delegate void Bind_handler (AppWindow window);
        public AppWindow bind (Bind_handler handle){
            handle(this);
            return this;
        }

        public AppWindow (Adw.Application app) {
            if(WidgetGeneric.gsettings == null)
                WidgetGeneric.gsettings = new GLib.Settings (app.get_application_id ());
            widget = new Adw.ApplicationWindow (app);
            widget.icon_name = app.application_id;
        }
    }


    public struct WidgetGenericStruct<G> {
        public G _widget;
    }

    public struct AppWindowS : WidgetGenericStruct<Adw.ApplicationWindow> {

        public AppWindowS child (WidgetGenericStruct<Gtk.Widget> c) {
            _widget.set_content (c._widget);
            return this;
        }

        public AppWindowS (Adw.Application app) {
            _widget = new Adw.ApplicationWindow (app);
            _widget.icon_name = app.application_id;
        }
    }

    protected delegate unowned void Action ();
    public struct ButtonS : WidgetGenericStruct<Gtk.Button> {

        public ButtonS () {
            _widget = new Gtk.Button();
        }
        public ButtonS.from_icon_name (string icon_name) {
            _widget = new Gtk.Button.from_icon_name(icon_name);
        }
        public ButtonS.with_label (string label) {
            _widget = new Gtk.Button.with_label (label);
        }
        public ButtonS on_click (Action action){
            this._widget.clicked.connect (action);
            return this;
        }

    }

    public struct Window {
        Adw.ApplicationWindow _root;
        Gtk.Widget child;

        public Window() {
        }
    }

     public struct Buttons {
        Gtk.Button _root;

        Gtk.Widget child;

        public Gtk.Button build() {
            return _root;
        }

        public Buttons(string str) {
            _root = new Gtk.Button.with_label(str);
        }
    }

    public class Navigation : WidgetGeneric<Navigation, Adw.NavigationView> {
        protected delegate void Action (Navigation nav);

        public Navigation bind (Action handle){
            handle(this);
            return this;
        }

        public Navigation on_pushed (owned Action handle){
            this.widget.pushed.connect (() => {
                handle(this);
            });
            return this;
        }

        public Navigation add_action (string action_name, Action handle) {
            var new_action = new SimpleAction("nav." + action_name, null);
            new_action.activate.connect(() => handle(this));

            simple_action_group.add_action(new_action);
            return this;
        }

        public Navigation push_later (params VuiDepr.Page[] c) {
            foreach (var item in c){
                widget.add (item.widget);
                print("page %s added\n", item.widget.tag);
            }
            return this;
        }

        public Navigation (params VuiDepr.Page[] c) {
            widget = new Adw.NavigationView ();
            foreach (var item in c){
                this.widget.push (item.widget);
                widget.add (item.widget);
                print("page %s added\n", item.widget.tag);
            }

            this.add_action ("pop", (nav) => nav.widget.pop ());
        }
    }

    public class Page : WidgetGeneric<Page, Adw.NavigationPage> {

        public Page can_pop (bool can_pop) {
            this.widget.set_can_pop (can_pop);
            return this;
        }

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

        public Label.ref (String? label = null, Store? state = null) {
            widget = new Gtk.Label (label());
            if(state != null)
                state.changed.connect (() => {
                   widget.label = label();
                });
        }

        public Label (string label) {
            widget = new Gtk.Label (label);
        }

    }

    public class Image : WidgetGeneric<Image, Gtk.Image>{

        public Image pixel_size (int size) {
            this.widget.set_pixel_size (size);
            return this;
        }

        public Image() {
            this.widget = new Gtk.Image ();
        }
        public Image.from_icon_name (string? icon_name) {
            this.widget = new Gtk.Image.from_icon_name (icon_name);
        }
        public Image.from_resource (string? resource_path) {
            this.widget = new Gtk.Image.from_resource (resource_path);
        }
    }

    public class Picture : WidgetGeneric<Picture, Gtk.Picture> {

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
        protected delegate void action ();
        public Button do(owned action actions){
            widget.clicked.connect (() => actions());
            return this;
        }
        public Button (WidgetGeneric<WidgetGeneric, Gtk.Widget>? child = null) {
            widget = new Gtk.Button();
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

    public class Dialog :  WidgetGeneric<Navigation, Adw.Dialog> {
        public Dialog title (string title) {
            this.widget.set_title (title);
            return this;
        }

        public Dialog content_size (int width, int height) {
            this.widget.set_content_width (width);
            this.widget.set_content_height (height);
            return this;
        }

        public Dialog follows_content_size(bool does_it) {
            this.widget.follows_content_size = does_it;
            return this;
        }

        public Dialog child (WidgetGeneric<WidgetGeneric, Gtk.Widget> c) {
            this.widget.set_child (c.widget);
            return this;
        }
        public Dialog () {
            var content = new VuiDepr.VBox ();
            this.widget = new Adw.Dialog () {
			    child = content.widget,
			    content_width = 600,
			    content_height = 550
            };
            this.widget.present(VuiDepr.App._active_window_);
            this.widget.show();
        }
    }

    public class AlertDialog : WidgetGeneric<AlertDialog, Adw.AlertDialog> {
        protected delegate void Action (string response);

        public AlertDialog on_response (Action action) {
            this.widget.response.connect ((res) => action(res));
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
            this.widget.present(VuiDepr.App._active_window_);
            this.widget.show();
        }
    }

    public class Entry : WidgetGeneric<Entry, Gtk.Entry> {
        public Entry(string placeholder, Store<string>? write_to = null) {
            this.widget = new Gtk.Entry();
            this.widget.set_placeholder_text (placeholder);

            if(write_to != null)
                this.widget.changed.connect (() => {
                    print("typed: %s\n", this.widget.text);
                   write_to.state = this.widget.text;
                });
        }
    }

    // public struct EntryS {
    //     Gtk.Entry _root;
    //     public EntryS(string s, Store<string>? write_to = null) {
    //         _root = new Gtk.Entry();
    //         if(write_to != null)
    //             _root.changed.connect (() => {
    //                 print("typed: %s\n", this.widget.text);
    //                write_to.state = this.widget.text;
    //             });
    //     }
    // }

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


