import Foundation

var configCandidateNum: Int = 10;
let dict_filename = ".ihelper.csv"

struct Candidate: Hashable {
    let tag: String
    let desc: String
    let output: String
    let iftext: Bool
    let id: Int
}

class DataBaseClient{
    static let shared = DataBaseClient()
    
    var filecontent: [(String,String,String,Bool)]!
    
    func getCandidates(origin: String = String()) -> [Candidate] {
        let keywords = origin.components(separatedBy: ";")
        var reexp = ""
        for (i,k) in keywords.enumerated() {
            // (?=.*key1).*;(?=.*key2).*;(?=.*key3)
            reexp += "(?=.*"+NSRegularExpression.escapedPattern(for: k)+")"
            if i != keywords.count-1 {
                reexp += ".*;"
            }
        }
        let RE = try! NSRegularExpression(pattern: reexp, options: .caseInsensitive)
        var candidates:[Candidate] = []
        for (index,item) in filecontent.enumerated() {
            if RE.firstMatch(in: item.0, range: NSRange(location:0,length:item.0.count)) != nil {
                candidates.append(Candidate(tag: item.0, desc: item.1, output: item.2, iftext: item.3, id:index))
            }
        }
        
        return candidates
    }
    
    func loadDict(){ // parse .csv
        let path = NSHomeDirectory()+"/" + dict_filename
        if !FileManager.default.fileExists(atPath:path) {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
        let text = try! String(contentsOfFile:path, encoding: String.Encoding.utf8)
        let lines = text.split{ [Character("\n"), Character("\r"), Character("\r\n")].contains($0) }
        var kvs = [(String,String,String,Bool)]()
        for l in lines{
            if let s = parseCSVline(String(l)) { kvs.append(s)}
        }
        filecontent = kvs
    }
    
    init() {
        loadDict()
    }
}

func parseCSVline(_ l: String) -> (String,String,String,Bool)?{
    var spans = ["","","",""]
    var spanIndex = 0
    var openclose = false
    for char in l.appending(",") {
        switch char {
        case "\"":
            if openclose == false {
                openclose = true
            }else{
                openclose = false
                spans[spanIndex] += "\""
            }
        case ",":
            if openclose == false {
                if spans[spanIndex].last == "\""{
                    spans[spanIndex].remove(at: spans[spanIndex].index(before: spans[spanIndex].endIndex))
                }
                if spanIndex == 3 {
                    break
                }
                spanIndex+=1
            }else{
                spans[spanIndex] += ","
            }
        default:
            spans[spanIndex] += String(char)
        }
    }
    
    if spans[1].count == 0 {
        return nil
    }
    if spans[3] == "2" {
        return ((spans[0],spans[1],spans[2],false))
    } else {
        return ((spans[0],spans[1],spans[2],true))
    }
}
