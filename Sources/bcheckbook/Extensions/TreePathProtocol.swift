import Gtk
import CGtk
import GLibObject
import Glib

extension TreePathProtocol {
    var index: Int {
        return Int(self.getIndices().pointee)
    }
}