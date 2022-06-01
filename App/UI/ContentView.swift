import SwiftUI

let w :CGFloat = 400
let color1 = Color(red:255,green:255,blue:255,opacity:0.9)
let color2 = Color(red:255,green:255,blue:255,opacity:0.7)
let itemselectedbg = Color.purple.opacity(0.3)
let itemHeight: CGFloat = 34

struct Tags: View {
    var tag: String
    var body: some View {
        let c = Color(red:194/255,green:194/255,blue:240/255)
        HStack(spacing:1){
            Text("@")
                .foregroundColor(c).bold().opacity(0.8)
            ForEach(tag.split(separator: ";"), id: \.self) { t in
                Text(t)
                    .foregroundColor(c)
                Text(";")
                    .foregroundColor(c).bold().opacity(0.6)
            }
        }.fixedSize(horizontal: true, vertical: false).padding(2).padding(.leading,3).background(Color(red:63/255,green:62/255,blue:61/255,opacity: 0.6))
    }
}

struct TruncableItem: View {
    let candidate: Candidate
    let ifselected: Bool
    
    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    @State private var isTruncated: Bool = false
    var body: some View {
        let bg  = ifselected ? itemselectedbg : Color.clear
        Group{
            if isTruncated && ifselected {
                ScrollView{
                    VStack(alignment: .leading, spacing: 5) {
                        Text(candidate.desc).foregroundColor(color1).fixedSize(horizontal: false, vertical: true)
                        Tags(tag: candidate.tag)
                        Text(candidate.output).foregroundColor(color2)
                            .font(.system(size: CGFloat(15)))
                    }.frame(width:w-20, alignment: .leading)
                }
                .padding(5)
                .padding(.leading,5)
                .padding(.trailing,5)
                .frame(width:w, alignment: .leading)
                .fixedSize()
            }else{
                HStack(alignment:.firstTextBaseline){
                    Text("\(candidate.desc)")
                        .foregroundColor(color1)
                        .frame(maxWidth: w, alignment: .leading)
                    Tags(tag: candidate.tag)
                    Text(candidate.output)
                        .foregroundColor(Color.gray)
                }
                .padding(5)
                .padding(.leading,5)
                .padding(.trailing,5)
                .fixedSize(horizontal: true, vertical: false)
                .frame(height:itemHeight, alignment: .center)
                .readSize { size in
                    isTruncated = (CGFloat(size.width) > w)
                }
                
            }
        }.frame(width: w, alignment: .leading).background(bg)
            .font(.system(size: CGFloat(16)))
    }
}

struct ContentView: View {
    var candidates: [Candidate]
    var origin: String
    var curPage: Int = 1
    var hasNext: Bool = false
    var selectedI: Int = -1
    var error = ""
    
    var body: some View {
        let inputbg = -1 == selectedI
        ? itemselectedbg
        : Color(red:55/255,green: 53/255,blue: 54/255)
        
        return HStack(alignment:.top, spacing:20){
            VStack(alignment: .leading, spacing: 20) {
                if error.count > 0  {
                    Text(error).foregroundColor(Color.white).font(.system(size: CGFloat(20)))
                        .padding(.top, 3)
                        .padding(.bottom, 3)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .frame(width:w, alignment: .leading)
                        .background(Color.red)
                }else{
                    // header
                    HStack(alignment:.center){
                        Text(">  " + (selectedI > -1 ? candidates[selectedI].output : origin)).foregroundColor(color1).frame(maxWidth:w-24-20, alignment: .leading)
                            .fixedSize(horizontal: true, vertical: false)
                        Spacer()
                        Text("\(curPage)").foregroundColor(Color.gray)
                    }.font(.system(size: CGFloat(20)))
                        .padding(.top, 3)
                        .padding(.bottom, 5)
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                        .frame(width:w-20, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: false)
                        .background(inputbg)
                        .cornerRadius(6)
                        .padding(10)
                        .padding(.top,3)
                        .padding(.bottom,-20)
                        
                    
                    // plane
                    HStack(alignment:.top){
                        // list
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(candidates.enumerated()), id: \.element.id) { (index, candidate) in
                                
                                TruncableItem(candidate: candidate, ifselected: selectedI == index)
                                
                            }
                        }
                    }
                }}
            .padding(.bottom,5)
            .frame(width:w, alignment: .leading)
            .cornerRadius(6)
            .background(Color(red:37/255,green:36/255,blue:34/255))
            .padding(6)
            .cornerRadius(6)
            .border(Color.gray.opacity(0.3),width:6)
            .cornerRadius(6)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(candidates: [
            Candidate(tag: "vim;", desc: "跳转至最后一行 跳转至最后一跳转至最后一行 跳转至最后一行跳转至最后一行 跳转至最后一跳转至最后一行 跳转至最后一行", output: "G 跳转至最后一至最后一行 跳转至最后一行 跳转至最后一行 跳转至最后一行 ", iftext: true,id:0),
            Candidate(tag: "vim;ae;", desc: "跳转至第一行", output: "gg",iftext: false,id:1),
            Candidate(tag: "vim;appe;", desc: "跳转至行尾", output: "g$" , iftext: true,id:2),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化", output: "" , iftext: false,id:4),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化", output: "" , iftext: false,id:3),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化", output: "" , iftext: true,id:5),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化", output: "" , iftext: true,id:6),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化", output: "" , iftext: true,id:7),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化", output: "12345678912345678911111" , iftext: true,id:8),
            Candidate(tag: "vim;", desc: "shift+V 进入可视化可视化可视化可", output: "12345678" , iftext: true,id:9),
        ], origin:"vim1234567891234567891111112345678912345678911111", selectedI:-1,error: "")
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
        backgroundColor = .clear
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
        var left = originalTopLeft.x
        var top = originalTopLeft.y
        
        if let curScreen = getScreenFromPoint(originalTopLeft) {
            let screen = curScreen.frame
            left = (screen.maxX - screen.minX)/2 - (w)/2
            top = (screen.maxY - screen.minY)/2 + 300
        }
        return NSPoint(x: left, y: top)
    }
    
    static let shared = CandidatesWindow()
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
