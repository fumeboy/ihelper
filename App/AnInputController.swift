import Cocoa
import InputMethodKit

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

class AnInputController: IMKInputController {
    private var _candidates: [Candidate] = []
    private var _candidatesNow: [Candidate] = []
    private var _hasNext: Bool = false
    private var _selector: Int = -1
    private var ifbanned: Bool = false
    private var err: String = "" {
        didSet{
            if self.err.count == 0 {
                CandidatesWindow.shared.close()
            }else{
                CandidatesWindow.shared.setError(err: err)
            }
        }
    }
    
    private var _originalString = "" {
        didSet(old){
            curPage = 1
            _selector = -1
            client()?.setMarkedText(_originalString, selectionRange:NSMakeRange(_originalString.count, 0), replacementRange: replacementRange())
            if self._originalString.count == 0{
                CandidatesWindow.shared.close()
                return
            }
            if _candidates.count != 0
                || (old.count == 0 &&  self._originalString.count > 0)
                || old.count > self._originalString.count {
                _candidates = DataBaseClient.shared.getCandidates(origin: self._originalString)
            }
            refreshCandidatesWindow()
        }
    }
    private var curPage: Int = 1
    private var pageItemNum: Int = 0
    func refreshCandidatesWindow() {
        let starti = (curPage-1)*configCandidateNum
        let endi = curPage*configCandidateNum
        _hasNext = _candidates.count > endi
        
        _candidatesNow =  Array(_candidates.count > starti ?
        _hasNext ? _candidates[starti..<endi] : _candidates[starti..<_candidates.count]
        :
        [])
        CandidatesWindow.shared.setCandidates(
            _candidatesNow,
            curPage: curPage,
            hasNext: _hasNext,
            originalString: _originalString,
            topLeft_: getOriginPoint()
        )
    }
    
    private func arrowKeyHandler(event: NSEvent) -> Bool? {
        if _originalString.count > 0{
            if event.keyCode == kVK_RightArrow {
                if _hasNext {
                    curPage += 1
                    _selector = -1
                    self.refreshCandidatesWindow()
                }
                return true
            }
            if event.keyCode == kVK_LeftArrow {
                if curPage > 1 {
                    curPage -= 1
                    _selector = -1
                    self.refreshCandidatesWindow()
                }
                return true
            }
            if event.keyCode == kVK_UpArrow {
                if _selector >= 0 {
                    _selector -= 1
                    CandidatesWindow.shared.setSelector(i: _selector)
                }
                return true
            }
            if event.keyCode == kVK_DownArrow {
                if _selector < _candidatesNow.count-1 {
                    _selector += 1
                    CandidatesWindow.shared.setSelector(i: _selector)
                }
                return true
            }
        }
        return nil
    }
    
    private func deleteHandler(event: NSEvent) -> Bool? {
        if event.keyCode == kVK_Delete {
            if _originalString.count > 0 {
                _originalString = String(_originalString.dropLast())
                return true
            }
            return false
        }
        return nil
    }
    
    private func escHandler(event: NSEvent) -> Bool? {
        if event.keyCode == kVK_Escape  {
            ctrl_press_times+=1
            if _originalString.count > 0 {
                clean()
            }else{
                if ctrl_press_times >= 2 {
                    ifbanned = false
                    toast.show("control mode")
                }else{
                    ifbanned = !ifbanned
                    if ifbanned {
                        toast.show("banning mode")
                    }else{
                        toast.show("normal mode")
                    }
                }
            }
            return true
        }
        return nil
    }
    
    static let ascii:String = String(Array(32...126).map { Character(Unicode.Scalar($0)) })
    private func inputHandler(event: NSEvent) -> Bool? {
        if event.modifierFlags.rawValue != 0 && event.modifierFlags != .shift {
            // check if .command .option .control is pressing
            return nil
        }
        if event.characters != nil{
            if AnInputController.ascii.contains(event.characters!) {
                _originalString += event.characters!
                return true
            }
        }
        return nil
    }
    
    
    static let keycode: [String: UInt16] = [
        // a-z
        "a": UInt16(kVK_ANSI_A),
        "b": UInt16(kVK_ANSI_B),
        "c": UInt16(kVK_ANSI_C),
        "d": UInt16(kVK_ANSI_D),
        "e": UInt16(kVK_ANSI_E),
        "f": UInt16(kVK_ANSI_F),
        "g": UInt16(kVK_ANSI_G),
        "h": UInt16(kVK_ANSI_H),
        "i": UInt16(kVK_ANSI_I),
        "j": UInt16(kVK_ANSI_J),
        "k": UInt16(kVK_ANSI_K),
        "l": UInt16(kVK_ANSI_L),
        "m": UInt16(kVK_ANSI_M),
        "n": UInt16(kVK_ANSI_N),
        "o": UInt16(kVK_ANSI_O),
        "p": UInt16(kVK_ANSI_P),
        "q": UInt16(kVK_ANSI_Q),
        "r": UInt16(kVK_ANSI_R),
        "s": UInt16(kVK_ANSI_S),
        "t": UInt16(kVK_ANSI_T),
        "u": UInt16(kVK_ANSI_U),
        "v": UInt16(kVK_ANSI_V),
        "w": UInt16(kVK_ANSI_W),
        "x": UInt16(kVK_ANSI_X),
        "y": UInt16(kVK_ANSI_Y),
        "z": UInt16(kVK_ANSI_Z),
        // Numbers 0-9
        "0": UInt16(kVK_ANSI_0),
        "1": UInt16(kVK_ANSI_1),
        "2": UInt16(kVK_ANSI_2),
        "3": UInt16(kVK_ANSI_3),
        "4": UInt16(kVK_ANSI_4),
        "5": UInt16(kVK_ANSI_5),
        "6": UInt16(kVK_ANSI_6),
        "7": UInt16(kVK_ANSI_7),
        "8": UInt16(kVK_ANSI_8),
        "9": UInt16(kVK_ANSI_9),
        // Arithmetic operators
        "+": UInt16(kVK_ANSI_KeypadPlus),
        "-": UInt16(kVK_ANSI_Minus),
        "*": UInt16(kVK_ANSI_KeypadMultiply),
        "=": UInt16(kVK_ANSI_Equal),
        // F1-F20
        "f1": UInt16(kVK_F1),
        "f2": UInt16(kVK_F2),
        "f3": UInt16(kVK_F3),
        "f4": UInt16(kVK_F4),
        "f5": UInt16(kVK_F5),
        "f6": UInt16(kVK_F6),
        "f7": UInt16(kVK_F7),
        "f8": UInt16(kVK_F8),
        "f9": UInt16(kVK_F9),
        "f10": UInt16(kVK_F10),
        "f11": UInt16(kVK_F11),
        "f12": UInt16(kVK_F12),
        "f13": UInt16(kVK_F13),
        "f14": UInt16(kVK_F14),
        "f15": UInt16(kVK_F15),
        "f16": UInt16(kVK_F16),
        "f17": UInt16(kVK_F17),
        "f18": UInt16(kVK_F18),
        "f19": UInt16(kVK_F19),
        "f20": UInt16(kVK_F20),
        // Other keys
        "'": UInt16(kVK_ANSI_Quote),
        "`": UInt16(kVK_ANSI_Grave),
        "capslock": UInt16(kVK_CapsLock),
        "delete": UInt16(kVK_ForwardDelete),
        "return": UInt16(kVK_Return),
        "tab": UInt16(kVK_Tab),
        "esc": UInt16(kVK_Escape),
        ",": UInt16(kVK_ANSI_Comma),
        ".": UInt16(kVK_ANSI_KeypadDecimal),
        "(": UInt16(kVK_ANSI_LeftBracket),
        ")": UInt16(kVK_ANSI_RightBracket),
        ";": UInt16(kVK_ANSI_Semicolon),
        "/": UInt16(kVK_ANSI_Slash),
        "space": UInt16(kVK_Space),
        "command": UInt16(kVK_Command),
        "cmd": UInt16(kVK_Command),
        "control": UInt16(kVK_Control),
        "ctrl": UInt16(kVK_Control),
        "fn": UInt16(kVK_Function),
        "option": UInt16(kVK_Option),
        "shift": UInt16(kVK_Shift),
        "down": UInt16(kVK_DownArrow),
        "left": UInt16(kVK_LeftArrow),
        "right": UInt16(kVK_RightArrow),
        "up": UInt16(kVK_UpArrow),
    ]

    private func insertHandler(event: NSEvent) throws -> Bool? {
        if (event.keyCode == kVK_Return || event.keyCode == kVK_Tab || event.keyCode == kVK_Space) {
            if _originalString.count == 0 {
                return false
            }
            if _selector == -1 {
                client()?.insertText(NSAttributedString(string: _originalString), replacementRange: replacementRange())
                clean()
                ifbanned = true
                toast.show("banning mode")
                
                if event.keyCode == kVK_Tab || event.keyCode == kVK_Space {
                    return false
                }
            }else{
                if _candidatesNow[_selector].iftext {
                    client()?.insertText(NSAttributedString(string: _candidatesNow[_selector].output), replacementRange: replacementRange())
                    clean()
                }else{
                    let keys: [String] = _candidatesNow[_selector].output.components(separatedBy: "+")
                    let press = keys.last!
                    var flags: UInt64 = 0
                    for k in keys.dropLast() {
                        switch k {
                        case "shift":
                            flags = CGEventFlags.maskShift.rawValue | flags
                        case "ctrl","control":
                            flags = CGEventFlags.maskControl.rawValue | flags
                        case "command","cmd":
                            flags = CGEventFlags.maskCommand.rawValue | flags
                        case "option":
                            flags = CGEventFlags.maskAlternate.rawValue | flags
                        default: throw "bad expression of hotkey: " + "\(keys)"
                        }
                    }
                    if let v = AnInputController.keycode[press] {
                        clean()
                        let up = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(v), keyDown: false);
                        let down = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(v), keyDown: true);
                        if flags != 0 {
                            down?.flags = CGEventFlags(rawValue: flags);
                            up?.flags = CGEventFlags(rawValue: flags);
                        }
                        down?.post(tap: CGEventTapLocation.cghidEventTap);
                        up?.post(tap: CGEventTapLocation.cghidEventTap);
                    }else{
                        throw "bad expression of hotkey (at the last key): " + _candidatesNow[_selector].output
                    }
                }
            }
            return true
        }
        return nil
    }
    
    private var ctrl_press_times : Int = 0
    override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        if err.count > 0 {
            err = ""
            return true
        }
        if let r = escHandler(event: event) {
            return r
        }
        if ctrl_press_times >= 2 { // press ESC twice to open control mode
            ctrl_press_times = 0
            if event.characters == nil{
                return false
            }
            
            func shell(_ command: String) -> String {
                let task = Process()
                let pipe = Pipe()
                task.standardOutput = pipe
                task.standardError = pipe
                task.arguments = ["-c", command]
                task.launchPath = "/bin/bash"
                task.standardInput = nil
                task.launch()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)!
                return output
            }
            
            switch event.characters!{
            case "s","S":
                DataBaseClient.shared.loadDict()
                clean()
                return true
            case "w", "W":
                _ = shell("open -a TextEdit ~/"+dict_filename)
                return true
            default:
                return false
            }
        }
        ctrl_press_times = 0
        if !ifbanned {
            for handler in [
                arrowKeyHandler,
                insertHandler,
                deleteHandler,
                inputHandler,
            ] {
                do {
                    let r = try handler(event)
                    if  r != nil{
                        return r!
                    }
                }catch{
                    err = error.localizedDescription
                    return true
                }
            }
        }
        
        return false
    }
    
    // 获取当前输入的光标位置
    private func getOriginPoint() -> NSPoint {
        let xd: CGFloat = 12
        let yd: CGFloat = 4
        var rect = NSRect()
        client()?.attributes(forCharacterIndex: 0, lineHeightRectangle: &rect)
        return NSPoint(x: rect.minX + xd, y: rect.minY - yd)
    }
    
    func clean() {
        _originalString = ""
    }
    
    let toast = ToastWindow()
    
    override func deactivateServer(_ sender: Any!) {
        clean()
    }
}
