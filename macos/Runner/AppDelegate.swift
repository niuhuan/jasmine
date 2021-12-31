import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    override init() {
        super.init()
        let folder = NSHomeDirectory()+"/Library/Application Support/jasmine"
        let chars = folder.cString(using: String.Encoding.utf8)
        init_ffi(chars!)
    }
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}
