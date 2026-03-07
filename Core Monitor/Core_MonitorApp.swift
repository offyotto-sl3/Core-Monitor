import SwiftUI

@main
struct CoreMonitorApp: App {
    
    init() {
        // This forces the app to run as an accessory (no Dock icon)
        // even if the Info.plist setting is being ignored
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra("CPU", systemImage: "cpu") {
            ContentView()
            Divider()
            Button("Quit Core Monitor") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}

