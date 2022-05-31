import Foundation
import Cocoa
import SwiftUI
import InputMethodKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var server: IMKServer!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        server = IMKServer(
            name: "iHelper_1_Connection", bundleIdentifier: Bundle.main.bundleIdentifier)
        NSLog("start")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
}

let app = NSApplication.shared
let d = AppDelegate()
app.delegate = d
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
