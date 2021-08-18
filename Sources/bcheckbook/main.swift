import Gtk
import GLibObject
import CGtk
import GLib
import GLibObject
import GIO
import Foundation

let TEST_FILE = URL(fileURLWithPath: "/home/bryce/transactions.bcheck").standardizedFileURL

if let STORED_RECORDS = try? Record.load(from: TEST_FILE) {
    for record in STORED_RECORDS {
        Records.shared.add(record)
    }
}

let status = Application.run(startupHandler: { app in
    if let builder = Builder("menus") {
        app.menubar = builder.get("menuBar", MenuModelRef.init)
    }
}) { app in
    guard let builder = Builder("window") else {
        print("Could not build the application user interface")
        app.quit()
        return
    }
    let window = ApplicationWindowRef(application: app)
    window.title = "Hello, World!"
    window.setDefaultSize(width: 320, height: 240)
    
    let scrollView = builder.get("scrollView", ScrolledWindowRef.init)
    let iterator = TreeIter()
    let store = ListStore(builder.get("store", Gtk.ListStoreRef.init).list_store_ptr)!
    // let listView = builder.get("treeView", TreeViewRef.init)

    window.add(widget: scrollView)
    for record in Records.shared.sortedRecords {
        switch record.event.type {
            case .deposit:
                if let checkNumber = record.event.checkNumber {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    Value("\(checkNumber)"),
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                } else {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    "N/A",
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                }
            case .withdrawal:
                if let checkNumber = record.event.checkNumber {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    Value("\(checkNumber)"),
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                } else {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    "N/A",
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                }
        }
    }
    window.showAll()
    /* let listView = ListView(model: store)
    let columns = [
        ("Date", "text", CellRendererText()),
        ("Check #", "text", CellRendererText()),
        ("Reconciled", "active", CellRendererToggle()),
        ("Vendor", "text", CellRendererText()),
        ("Memo", "text", CellRendererText()),
        ("Deposit", "text", CellRendererText()),
        ("Withdrawal", "text", CellRendererText()),
        ("Balance", "text", CellRendererText())
    ].enumerated().map {(i: Int, c:(title: String, kind: PropertyName, renderer: CellRenderer)) in
        TreeViewColumn(i, title: c.title, renderer: c.renderer, attribute: c.kind)
    }
    listView.append(columns)
    window.add(widget: listView)
    for record in Records.shared.sortedRecords {
        switch record.event.type {
            case .deposit:
                if let checkNumber = record.event.checkNumber {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    Value("\(checkNumber)"),
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                } else {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    "N/A",
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                }
            case .withdrawal:
                if let checkNumber = record.event.checkNumber {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    Value("\(checkNumber)"),
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                } else {
                    store.append(asNextRow: iterator,
                    Value(Event.DF.string(from: record.event.date)),
                    "N/A",
                    Value(record.event.isReconciled),
                    Value(record.event.vendor),
                    Value(record.event.memo),
                    "N/A",
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!),
                    Value(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!))
                }
        }
    }
    window.showAll() */
}

guard let status = status else {
    fatalError("Could not create Application")
}

guard status == 0 else {
    fatalError("Application exited with status \(status)")
}