import Cocoa
import SwiftUI

class ToastWindow: NSWindow {
    struct ToastView: View {
        var text: String
        var body: some View {
            VStack {
                Text(text)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            .fixedSize()
            .padding(20)
            .background(Color.black.opacity(0.5))
            .clipped()
            .cornerRadius(20)
        }
    }

    struct ToastView_Previews: PreviewProvider {
        static var previews: some View {
            ToastView(text: "banning mode")
        }
    }

    private var timer: Timer?

    private let hostingView = NSHostingView(rootView: ToastView(text: "normal mode"))
    override var acceptsFirstResponder: Bool {
       return false
    }

    private func initWindow() {
        isOpaque = false
        backgroundColor = NSColor.clear
        styleMask = .init(arrayLiteral: .borderless, .fullSizeContentView)
        hasShadow = false
        ignoresMouseEvents = true
        isReleasedWhenClosed = false
        level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(CGShieldingWindowLevel()))
    }
    override init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        initWindow()
        contentView = hostingView
    }

    private func positionWindow() {
        guard let screen = getScreenFromPoint(NSEvent.mouseLocation) else {
            return
        }
        let cx = (screen.frame.minX + screen.frame.maxX) / 2 - frame.width / 2
        let cy = (screen.frame.maxY - screen.frame.minY) / 5 + screen.frame.minY
        self.setFrameOrigin(NSPoint(x: cx, y: cy))
    }

    func show(_ text: String) {
        timer?.invalidate()
        hostingView.rootView.text = text
        positionWindow()
        orderFront(nil)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            self.close()
        })
    }
}
