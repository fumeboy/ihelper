import SwiftUI

let w1 :CGFloat = 280
let w2 :CGFloat = 250
let color1 = Color(red:255,green:255,blue:255,opacity:0.9)
let color2 = Color(red:255,green:255,blue:255,opacity:0.7)

struct ContentView: View {
    var candidates: [Candidate]
    var origin: String
    var curPage: Int = 1
    var hasNext: Bool = false
    var selectedI: Int = -1
    var ifexpand = false
    var error = ""
    
    var body: some View {
        let w : CGFloat = ifexpand && error.count == 0 ? w1+w2 : w1
        let inputbg = -1 == selectedI
        ? Color.purple.opacity(0.5)
        : Color(red:255,green:255,blue:255,opacity:0)
        return VStack(alignment: .leading, spacing: 0) {
            if error.count > 0  {
                Text(error).foregroundColor(Color.white).font(.system(size: CGFloat(20)))
                    .padding(.top, 3)
                    .padding(.bottom, 3)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .frame(width:w1, alignment: .leading)
                    .background(Color.red)
            }else{
                // header
                HStack(alignment:.firstTextBaseline){
                    Text(">  " + origin).foregroundColor(color1).minimumScaleFactor(0.9).frame(maxWidth:w - 70, alignment: .leading)
                        .fixedSize(horizontal: true, vertical: false)
                    Spacer()
                    Text("\(curPage)").foregroundColor(Color.gray)
                }.font(.system(size: CGFloat(20)))
                    .padding(.top, 3)
                    .padding(.bottom, 3)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .background(inputbg)
                    .frame(width:w, alignment: .leading)
                // plane
                HStack(spacing:0){
                    // list
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(candidates.enumerated()), id: \.element.id) { (index, candidate) in
                            let bgcolor = index == selectedI
                            ? candidate.output.count > 0 ? Color.purple.opacity(0.5) : Color.gray.opacity(0.4)
                            : Color(red:255,green:255,blue:255,opacity:0)
                            
                            let desc = Text("\(candidate.desc)").foregroundColor(color1).minimumScaleFactor(0.8)
                            let text = Text("\(candidate.output)").foregroundColor(color2).minimumScaleFactor(0.9)
                            let tag = Text("@\(candidate.tag)").foregroundColor(Color.orange).bold()
                            
                            GroupBox(){
                                if candidate.tag.count + candidate.desc.count + candidate.output.count < 30 {
                                    HStack(alignment:.firstTextBaseline){
                                        desc
                                        tag
                                        text
                                    }
                                }else{
                                    VStack(alignment:.leading){
                                        if candidate.desc.count + candidate.tag.count < 20 {
                                            HStack(alignment:.firstTextBaseline){
                                                desc
                                                tag
                                            }
                                            text.font(.system(size: CGFloat(15)))
                                        }else {
                                            desc
                                            if candidate.output.count + candidate.tag.count < 20 {
                                                HStack(alignment:.firstTextBaseline){
                                                    tag
                                                    text
                                                }.font(.system(size: CGFloat(15)))
                                            }else{
                                                tag.font(.system(size: CGFloat(15)))
                                                text.font(.system(size: CGFloat(15)))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.leading, CGFloat(5))
                            .padding(.trailing, CGFloat(5))
                            .font(.system(size: CGFloat(17)))
                            .frame(width:w1, alignment: .leading)
                            .background(bgcolor)
                            .fixedSize(horizontal: false, vertical: false)
                        }
                    }
                    
                    // detail plane
                    if ifexpand && selectedI > -1{
                        ScrollView{
                            VStack(alignment:.leading, spacing:5){
                                Text(candidates[selectedI].desc).foregroundColor(Color.white)
                                Text("@"+candidates[selectedI].tag)
                                    .foregroundColor(Color.orange).bold()
                                Text(candidates[selectedI].output)
                                    .foregroundColor(Color.white)
                            }
                            .font(.system(size: CGFloat(16)))
                            .padding(.leading, 8)
                            .padding(.trailing, 8)
                            .padding(.bottom, 5)
                            .frame(width:w2, alignment: .leading)
                            .fixedSize()
                        }
                    }
                }
            }}
        .frame(width:w, alignment: .leading)
        .background(Color.black)
        .cornerRadius(2,antialiased: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(candidates: [
            Candidate(tag: "vim;", desc: "跳转至最后一行 跳转至最后一跳转至最后一行 跳转至最后一行跳转至最后一行 跳转至最后一跳转至最后一行 跳转至最后一行跳转至最后一行 跳转至最后一跳转至最后一行 跳转至最后一行跳转至最后一行 跳转至最后一跳转至最后一行 跳转至最后一行", output: "G 跳转至最后一至最后一行 跳转至最后一行 跳转至最后一行 跳转至最后一行 ", iftext: true,id:0),
            Candidate(tag: "vim;ae;", desc: "跳转至第一行", output: "gg",iftext: true,id:1),
            Candidate(tag: "vim;appe;", desc: "跳转至行尾", output: "g$" , iftext: true,id:2),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化", output: "" , iftext: true,id:3),
            
        ], origin: "vimvimvimvimvimvimvimvimvimvimvimvimvimvimvimvimvimvimvimvimvimvim",
                    selectedI:0,ifexpand: true,error: "")
    }
}

class CandidatesWindow: NSWindow, NSWindowDelegate {
    let hostingView = NSHostingView(rootView: ContentView(candidates: [], origin: ""))
    
    func setCandidates(
        _ candidatesData: [Candidate],
        curPage: Int,
        hasNext: Bool,
        originalString: String,
        topLeft_: NSPoint
    ) {
        self.hostingView.rootView.error = ""
        self.hostingView.rootView.selectedI = -1
        self.hostingView.rootView.candidates = candidatesData
        self.hostingView.rootView.origin = originalString
        self.hostingView.rootView.hasNext = hasNext
        self.hostingView.rootView.curPage = curPage
        var ifexpand_ = false
        for c in candidatesData {
            if c.desc.count + c.tag.count + c.output.count > 30 {
                ifexpand_ = true
                break
            }
        }
        self.hostingView.rootView.ifexpand = ifexpand_
        
        let origin = transformTopLeft(originalTopLeft:topLeft_)
        self.setFrameTopLeftPoint(origin)
        
        self.orderFront(nil)
        NSApp.setActivationPolicy(.prohibited)
    }
    
    func setSelector(i: Int){
        hostingView.rootView.selectedI = i
    }
    
    func setError(err: String){
        hostingView.rootView.error = err
    }
    
    override init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(CGShieldingWindowLevel()))
        styleMask = .init(arrayLiteral: .fullSizeContentView, .borderless)
        isReleasedWhenClosed = false
        backgroundColor = NSColor.clear
        delegate = self
        
        // 窗口大小可根据内容变化
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        guard self.contentView != nil else {
            return
        }
        self.contentView?.addSubview(hostingView)
        self.contentView?.leftAnchor.constraint(equalTo: hostingView.leftAnchor).isActive = true
        self.contentView?.rightAnchor.constraint(equalTo: hostingView.rightAnchor).isActive = true
        self.contentView?.topAnchor.constraint(equalTo: hostingView.topAnchor).isActive = true
        self.contentView?.bottomAnchor.constraint(equalTo: hostingView.bottomAnchor).isActive = true
    }
    
    private func transformTopLeft(originalTopLeft: NSPoint) -> NSPoint {
        let screenPadding: CGFloat = 6
        
        var left = originalTopLeft.x
        var top = originalTopLeft.y
        if let curScreen = getScreenFromPoint(originalTopLeft) {
            let screen = curScreen.frame
            if originalTopLeft.x + w1 + w2 > screen.maxX - screenPadding {
                left = screen.maxX - (w1 + w2) - screenPadding
            }
            if originalTopLeft.y - 400 < screen.minY + screenPadding {
                top = screen.minY + 400 + screenPadding
            }
        }
        return NSPoint(x: left, y: top)
    }
    
    func getScreenFromPoint(_ point: NSPoint) -> NSScreen? {
        // find current screen
        for screen in NSScreen.screens {
            if screen.frame.contains(point) {
                return screen
            }
        }
        return NSScreen.main
    }
    
    static let shared = CandidatesWindow()
}
