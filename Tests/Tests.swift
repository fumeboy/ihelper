//
//  aaaaTests.swift
//  aaaaTests
//
//  Created by admin on 2022/5/31.
//

import XCTest
@testable import ihelper

class Tests: XCTestCase {

    func testCSV() throws {
        guard let spans = parseCSVline("a,v,c,")else {throw ""}
        guard spans.3 else {throw ""}
        guard let spans = parseCSVline("a,v,c") else {throw ""}
        guard spans.3 else {throw ""}
        guard let spans = parseCSVline("a,v,c,d") else {throw ""}
        guard spans.3 == false else {throw ""}
        guard let spans = parseCSVline(#"a,v,c,",d""#) else {throw ""}
        guard spans.2 == ",d" else {throw spans.2}
        guard let spans = parseCSVline(#"a,v,c,",""d""#) else {throw ""}
        guard spans.2 == #","d"# else {throw spans.2}
        guard let spans = parseCSVline(#"a,v,c,",""""""d""#) else {throw ""}
        guard spans.2 == #","""d"# else {throw spans.2}
        guard let spans = parseCSVline(#"a,v,c,","""""",d""#) else {throw ""}
        guard spans.2 == #",""",d"# else {throw spans.2}
        
        print(parseCSVline("显示隐藏文件显示隐藏文件显示隐藏文件显示隐藏文件,显示隐藏文件显示隐藏文件显示隐藏文件显示隐藏文件,显示隐藏文件显示隐藏文件显示隐藏文件显示隐藏文件,"))
    }
    
}

