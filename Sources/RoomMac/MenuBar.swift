//  Contents of the sparkle in the menu bar: free space, last clean, and shortcuts to every
//  window plus "clean the safe things now". Rebuilt each time the menu opens.

import SwiftUI

/// Contents of the menu bar sparkle.
struct MenuBarContent: View {
    @Bindable var model: CleanupModel
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        if let s = DiskSpace.current() {
            Text("\(Bytes.string(s.free)) free of \(Bytes.string(s.total))")
            if s.usedFraction >= 0.9 { Text("Your Mac is almost full") }
        }
        if let last = History.shared.lastClean {
            Text("Last clean \(last.formatted(.relative(presentation: .named)))")
        } else {
            Text("No clean yet")
        }
        Divider()
        Button("Open Room for Mac") {
            openWindow(id: "main")
            NSApp.activate(ignoringOtherApps: true)
        }
        .keyboardShortcut("o")
        Button(model.quietCleanRunning ? "Cleaning…" : "Clean the safe things now") {
            Task {
                if let s = await model.quietClean() {
                    Notifier.post(title: String(localized: "Room for Mac cleaned up"),
                                  body: String(localized: "\(Bytes.string(s.totalSize)) moved to the Trash. Open Room for Mac to see the receipt."))
                } else {
                    Notifier.post(title: String(localized: "Nothing to clean"), body: String(localized: "The safe categories are already clean."))
                }
            }
        }
        .disabled(model.quietCleanRunning)
        Divider()
        Button("What Room for Mac did") { openWindow(id: "history"); NSApp.activate(ignoringOtherApps: true) }
        Button("Uninstall an app…") { openWindow(id: "uninstall"); NSApp.activate(ignoringOtherApps: true) }
        Button("Space map") { openWindow(id: "spacemap"); NSApp.activate(ignoringOtherApps: true) }
        Button("Clean the menu bar…") { openWindow(id: "menubar"); NSApp.activate(ignoringOtherApps: true) }
        Button("Sort Desktop & Downloads…") { openWindow(id: "sorter"); NSApp.activate(ignoringOtherApps: true) }
        SettingsLink { Text("Settings…") }
        Divider()
        Button("Quit Room for Mac") { NSApp.terminate(nil) }.keyboardShortcut("q")
    }
}
