import Gtk
import CGtk
import GLibObject
import GLib

extension TreeViewProtocol {
    var selectedRows: [Int] {
        var storage = UnsafeMutablePointer<GtkTreeModel>?.none
        var list: ListRef?
        withUnsafeMutablePointer(to: &storage) { ptr in
            list = self.getSelection().getSelectedRows(model: ptr)
        }

        guard let list = list else { return [] }

        var indices = [Int]()

        list.forEach { ptr in
            indices.append(TreePathRef(raw: ptr).index)
        }
        g_list_free_full(list._ptr) {
            gtk_tree_path_free($0!.assumingMemoryBound(to: GtkTreePath.self))
        }

        return indices
    }

    var selectedRoe: Int? {
        guard !self.selectedRows.isEmpty && self.selectedRows.count == 1 else { return nil }

        return selectedRows.first!
    }
}