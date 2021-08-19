import Gtk
import CGtk
import GLibObject
import GLib

public extension TreeModelProtocol {
    public func iterator(for index: Int) -> TreeIter? {
        var element = gint(index)

        let path = TreePath(indicesv: &element, length: 1)
        let iter = TreeIter()

        guard get(iter: iter, path: path) else { return nil }

        return iter
    }

    public var count: Int {
        return self.iterNChildren(iter: nil)
    }

    public var last: TreeIter? {
        self.iterator(for: self.count - 1)
    }

    public var first: TreeIter? {
        self.iterator(for: 0)
    }
}