import Gtk
import CGtk
import GLibObject
import GLib

extension TreePathProtocol {
    var index: Int {
        return Int(self.getIndices().pointee)
    }
}