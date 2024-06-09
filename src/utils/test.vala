namespace Test {
    public class HBox : Gtk.Box {
        private int[] _margins = new int[4];
        public int[] margins {
            get { return _margins; }
            set {
                this.margin_top = value[0];
                this.margin_end = value[1];
                this.margin_bottom = value [2];
                this.margin_start = value[3];
                _margins = value;
            }
        }

        public HBox (params Gtk.Widget[] children) {
            this.orientation =  Gtk.Orientation.HORIZONTAL;
            foreach (var item in children)
                this.append (item);
        }
    }

    public class VBox : Gtk.Box {
        private int[] _margins = new int[4];
        public int[] margins {
            get { return _margins; }
            set {
                this.margin_top = value[0];
                this.margin_end = value[1];
                this.margin_bottom = value [2];
                this.margin_start = value[3];
                _margins = value;
            }
        }
        public VBox (params Gtk.Widget[] children) {
            this.orientation = Gtk.Orientation.VERTICAL;
            foreach (var item in children)
                this.append (item);
        }
    }
}
