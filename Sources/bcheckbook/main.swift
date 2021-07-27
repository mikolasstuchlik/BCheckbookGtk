import Gtk
import GLibObject
import CGtk
import Foundation

let TEST_FILE = URL(fileURLWithPath: "~/transactions.bcheck").standardizedFileURL

if let STORED_RECORDS = try? Record.load(from: TEST_FILE) {
    for record in STORED_RECORDS {
        Records.shared.add(record)
    }
}

let status = Application.run(startupHandler: nil) { app in
    let window = ApplicationWindowRef(application: app)
    window.title = "Hello, World!"
    window.setDefaultSize(width: 320, height: 240)
    /* let label = LabelRef(str: "Hello, World!")
    window.add(widget: label)
    window.showAll() */
    let iterator = TreeIter()
    let store = ListStore(.string, .string, .boolean, .string, .string, .string, .string, .string)
    var listView = ListView(model: store)
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
                    "\(Event.DF.string(from: record.event.date))", 
                    "\(checkNumber)", 
                    record.event.isReconciled ? true : false,
                    "\(record.event.vendor)",
                    "\(record.event.memo)",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!)",
                    "N/A",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!)")
                } else {
                    store.append(asNextRow: iterator, 
                    "\(Event.DF.string(from: record.event.date))", 
                    "N/A", 
                    record.event.isReconciled ? true : false,
                    "\(record.event.vendor)",
                    "\(record.event.memo)",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!)",
                    "N/A",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!)")
                }
            case .withdrawal:
                if let checkNumber = record.event.checkNumber {
                    store.append(asNextRow: iterator, 
                    "\(Event.DF.string(from: record.event.date))", 
                    "\(checkNumber)", 
                    record.event.isReconciled ? true : false,
                    "\(record.event.vendor)",
                    "\(record.event.memo)",
                    "N/A",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!)",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!)")
                } else {
                    store.append(asNextRow: iterator, 
                    "\(Event.DF.string(from: record.event.date))", 
                    "N/A", 
                    record.event.isReconciled ? true : false,
                    "\(record.event.vendor)",
                    "\(record.event.memo)",
                    "N/A",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.event.amount))!)",
                    "\(Event.CURRENCY_FORMAT.string(from: NSNumber(value: record.balance))!)")
                }
        }
    }
    window.showAll()
}

guard let status = status else {
    fatalError("Could not create Application")
}

guard status == 0 else {
    fatalError("Application exited with status \(status)")
}