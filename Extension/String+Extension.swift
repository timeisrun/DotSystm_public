//
//  String+Extension.swift
//  DotSystem
//
//  Created by ccc on 2022/1/23.
//

import Foundation

extension String {
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    func isWhiteSpace() -> Bool {
        if self == "" {
            return true
        }
        
        var spaceCount = 0
        let strlen = self.count
        self.forEach { char in
            if char == " " {
                spaceCount += 1
            }
        }
        
        if strlen == spaceCount {
            return true
        }
        
        return false
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
    
    // substring
    //    let str = "Hello, playground"
    //    print(str.substring(from: 7))         // playground
    //    print(str.substring(to: 5))           // Hello
    //    print(str.substring(with: 7..<11))    // play
    func index(from: Int) -> Index {
        if from > self.count {
            return self.index(startIndex, offsetBy: self.count)
        } else {
            return self.index(startIndex, offsetBy: from)
        }
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
}
