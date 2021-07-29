import Foundation
import Gtk
import CGtk
import GLib
import GLibObject
import GIO

extension Builder {
    public convenience init?(_ resource: String) {
        self.init()
        guard let filepath = Bundle.module.path(forResource: resource, ofType: "ui") else {
            return nil
        }

        do {
            let _ = try addFromFile(filename: filepath)
        } catch {
            print(error)
            return nil
        }
    }

    public func get<T: ObjectProtocol>(_ identifier: UnsafePointer<gchar>, _ cons: (UnsafeMutableRawPointer) -> T) -> T {
        cons(getObject(name: identifier)!.ptr)
    }
}