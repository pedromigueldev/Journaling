namespace Vui {

    [GenericAccessors]
    public interface CommonWidgetModifiers<T, G> {
        public abstract G widget {get; set;}
        public virtual T spacing (int spacing){return this;}
        public virtual T expand (bool hexpand, bool vexpand){return this;}
        public virtual T valign (Gtk.Align align){return this;}
        public virtual T halign (Gtk.Align align){return this;}
        public virtual T margins (int top, int left, int bottom, int right){return this;}
        public virtual T css_classes (string[] css_classes){return this;}
        public virtual T height_request (int height) {return this;}
    }

    public class Navigation : CommonWidgetModifiers<Navigation, Adw.NavigationView> {
        private Adw.NavigationView _widget;

        public Adw.NavigationView widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Navigation spacing (int spacing) {
            return this;
        }

        public Navigation expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Navigation valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Navigation halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }

        public Navigation margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }

        public Navigation css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }


        public Navigation (params Vui.Page[] c) {
            widget = new Adw.NavigationView ();
            foreach (var item in c)
                widget.add (item.widget);
        }
    }

    public class Window : CommonWidgetModifiers<Window, Adw.ApplicationWindow> {
        private Adw.ApplicationWindow _widget;

        public Adw.ApplicationWindow widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Window spacing (int spacing) {
            return this;
        }

        public Window expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Window valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Window halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }

        public Window margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }

        public Window css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public Window child (CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget> c) {
            widget.set_content (c.widget);
            return this;
        }

        protected delegate void bind_handle (Adw.ApplicationWindow window);
        public Window bind (bind_handle handle){
            handle(this.widget);
            return this;
        }

        public Window handle () {
            var handle = new Gtk.WindowHandle ();
            handle.child = this.widget.child;
            widget.set_child (handle);
            return this;
        }

        public Window (Gtk.Application app) {
            widget = new Adw.ApplicationWindow (app);
            widget.icon_name = app.application_id;
        }
    }


    public class Page : CommonWidgetModifiers<Page, Adw.NavigationPage> {
        private Adw.NavigationPage _widget;

        public Adw.NavigationPage widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Page spacing (int spacing) {
            return this;
        }

        public Page expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Page valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Page halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }

        public Page margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }

        public Page css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public Page child ( CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget> c) {
            widget.set_child (c.widget);
            return this;
        }

        public Page (string title) {
            widget = new Adw.NavigationPage (new Gtk.Box (Gtk.Orientation.VERTICAL, 0), title);
            widget.set_tag (title.ascii_down());
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

    public class Label : CommonWidgetModifiers<Label, Gtk.Label> {
        private Gtk.Label _widget;

        public Gtk.Label widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Label spacing (int spacing) {
            return this;
        }

        public Label expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Label valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Label halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }

        public Label margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }

        public Label css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

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
            if(state != null)
                state.state_set.connect (() => {
                    widget.label = label();
                });
            widget = new Gtk.Label (label());

        }

    }


    public class Picture : CommonWidgetModifiers<Picture, Gtk.Picture> {
        private Gtk.Picture _widget;

        public Gtk.Picture widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Picture spacing (int spacing) {
            return this;
        }

        public Picture expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Picture valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Picture halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }

        public Picture margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }

        public Picture css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public override Picture height_request (int height) {
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

    public class Button : CommonWidgetModifiers<Button, Gtk.Button> {
        private Gtk.Button _widget;

        public Gtk.Button widget {
            get { return _widget; }
            set { _widget = value; }
        }

        public Button expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Button valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Button halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }

        public Button margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }

        public Button css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        protected delegate void action<T> ();

        public Button do(owned action actions){
            widget.clicked.connect (() => actions());
            return this;
        }
        public Button (action actions) {
            widget = new Gtk.Button ();
        }
        public Button.from_icon_name (string icon_name) {
            widget = new Gtk.Button.from_icon_name(icon_name);
        }
        public Button.with_label (string label) {
            widget = new Gtk.Button.with_label (label);
        }
    }

    public interface CommonWidgetModifiersP<G> {
        public abstract G widget {get; protected set;}
        public abstract int spacing {protected set;}
        public abstract bool[] expand { protected set;}
        public abstract Gtk.Align valign {protected set;}
        public abstract Gtk.Align halign {protected set;}
        public abstract int[] margins {protected set;}
        public abstract string[] css_classes {protected set;}
    }

    public class HBox : CommonWidgetModifiers<HBox, Gtk.Box> {
        private Gtk.Box _widget;

        public Gtk.Box widget {
            get { return _widget; }
            set { _widget = value; }
        }

        public HBox spacing (int spacing) {
            widget.set_spacing (spacing);
            return this;
        }

        public HBox expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public HBox valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public HBox halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }

        public HBox margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }

        public HBox css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public HBox (params CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget>[]? children) {
            _widget = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            if(children != null) {
                foreach (var item in children)
                    widget.append (item.widget);
            }
        }
    }


    public class VBox : CommonWidgetModifiers<VBox, Gtk.Box> {
        private Gtk.Box _widget;

        public Gtk.Box widget {
            get { return _widget; }
            set { _widget = value; }
        }

        public VBox spacing (int spacing) {
            widget.set_spacing (spacing);
            return this;
        }
        public VBox expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public VBox valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public VBox halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }
        public VBox margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }
        public VBox css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public VBox (params CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget>[]? children) {
            _widget = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            if(children != null) {
                foreach (var item in children)
                    widget.append (item.widget);
            }
        }
    }
    public class Separator : CommonWidgetModifiers<Separator, Gtk.Separator> {
        private Gtk.Separator _widget;

        public Gtk.Separator widget {
            get { return _widget; }
            set { _widget = value; }
        }

        public Separator css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public Separator(Gtk.Orientation orientation) {
            widget = new Gtk.Separator (orientation);
        }
    }
    public class Spacer : CommonWidgetModifiers<Spacer, Gtk.Separator> {
         private Gtk.Separator _widget;

        public Gtk.Separator widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Spacer spacing (int spacing) {
            return this;
        }
        public Spacer expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Spacer valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Spacer halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }
        public Spacer margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }
        public Spacer css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public Spacer () {
            _widget = new Gtk.Separator (Gtk.Orientation.VERTICAL) { css_classes = {"spacer"} };
        }
    }

    public class MenuButton : CommonWidgetModifiers<MenuButton, Gtk.MenuButton> {
         private Gtk.MenuButton _widget;

        public Gtk.MenuButton widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private MenuButton spacing (int spacing) {
            return this;
        }
        public MenuButton expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public MenuButton valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public MenuButton halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }
        public MenuButton margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }
        public MenuButton css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public MenuButton icon_name (string name){
            widget.set_icon_name (name);
            return this;
        }

        public MenuButton (CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget> p) {
            var popover = new Gtk.Popover () { child = p.widget };
            _widget = new Gtk.MenuButton () { popover = popover};
        }
    }

    public class Overlay : CommonWidgetModifiers<Overlay, Gtk.Overlay> {
        private Gtk.Overlay _widget;

        public Gtk.Overlay widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Overlay spacing (int spacing) {
            return this;
        }

        public Overlay expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Overlay valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Overlay halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }
        public Overlay margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }
        public Overlay css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public Overlay set_overlay (CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget> overlay) {
            widget.add_overlay (overlay.widget);
            return this;
        }

        public Overlay set_child (CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget> child) {
            widget.child = child.widget;
            return this;
        }

        public Overlay() {
            widget = new Gtk.Overlay ();
        }
    }

    public class ScrolledBox : CommonWidgetModifiers<ScrolledBox, Gtk.ScrolledWindow >  {
        private Gtk.ScrolledWindow _widget;

        public Gtk.ScrolledWindow  widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private ScrolledBox spacing (int spacing) {
            // widget.set_spacing (spacing);
            return this;
        }
        public ScrolledBox expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public ScrolledBox valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public ScrolledBox halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }
        public ScrolledBox margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }
        public ScrolledBox css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        // scrolled specific

        public ScrolledBox vscrollbar_policy (Gtk.PolicyType vscrollbar_policy ) {
            widget.vscrollbar_policy = vscrollbar_policy;
            return this;
        }

        public ScrolledBox hscrollbar_policy (Gtk.PolicyType hscrollbar_policy ) {
            widget.hscrollbar_policy = hscrollbar_policy;
            return this;
        }

        public ScrolledBox (CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget> child) {
            widget = new Gtk.ScrolledWindow ();
            widget.set_child (child.widget);
        }
    }

    public class Bin : CommonWidgetModifiers<Bin, Adw.Bin> {
        private Adw.Bin _widget;

        public Adw.Bin widget {
            get { return _widget; }
            set { _widget = value; }
        }

        private Bin spacing (int spacing) {
            // widget.set_spacing (spacing);
            return this;
        }
        public Bin expand (bool hexpand, bool vexpand) {
            widget.set_hexpand (hexpand);
            widget.set_vexpand (vexpand);
            return this;
        }
        public Bin valign (Gtk.Align align) {
            widget.set_valign (align);
            return this;
        }
        public Bin halign (Gtk.Align align){
            widget.set_halign (align);
            return this;
        }
        public Bin margins (int top, int left, int bottom, int right) {
            widget.margin_top = top;
            widget.margin_end = left;
            widget.margin_bottom = bottom;
            widget.margin_start = right;
            return this;
        }
        public Bin css_classes (string[] css_classes) {
            widget.set_css_classes (css_classes);
            return this;
        }

        public Bin overflow (Gtk.Overflow overflow) {
            widget.set_overflow (overflow);
            return this;
        }

        public Bin (CommonWidgetModifiers<CommonWidgetModifiers, Gtk.Widget> child) {
            widget = new Adw.Bin();
            widget.set_child(child.widget);
        }
    }
}

