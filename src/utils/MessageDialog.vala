namespace Journaling {
    public class MessageDialog : Adw.AlertDialog {

        Gtk.Box dialog_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 15);
        public Gtk.Entry entry = new Gtk.Entry() { placeholder_text = "Type your password" };

        public MessageDialog(Gtk.Window win, string entry_text, Gtk.Box custom_icon) {
            entry.set_visibility(false);

            dialog_box.append(custom_icon);
            dialog_box.append(
                new Gtk.Label(entry_text) {
                    css_classes = { "title-2" }, wrap = true, justify = Gtk.Justification.CENTER
                }
            );

            dialog_box.append(entry);

            this.set_extra_child(dialog_box);

            this.add_response("cancel", "Cancel");
            this.add_response("verify", "Verify");

            this.set_response_appearance("cancel", Adw.ResponseAppearance.DESTRUCTIVE);
            this.set_response_appearance("verify", Adw.ResponseAppearance.SUGGESTED);

            this.show();
        }

    }
}

