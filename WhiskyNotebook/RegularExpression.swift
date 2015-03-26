// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation

public struct RegExMatch {

    public let matched: Bool

    public let captures: [String]

    public init(matched: Bool, captures: [String]) {
        self.matched = matched
        self.captures = captures
    }
}

extension RegExMatch: Printable {
    public var description: String { return "<RegExMatch: matched=\(self.matched), captures=\(captures)>" }
}

extension RegExMatch: BooleanType {

    public var boolValue: Bool { return self.matched }
}


infix operator =~ { associativity left precedence 130 }

//
//public func =~ (input: String?, pattern: String) -> Bool {
//    return (input =~ pattern).matched
//}

public func =~ (input: String?, pattern: String) -> RegExMatch {
    if let input = input, let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil) {
        let matches = regex.matchesInString(input, options: nil, range: NSMakeRange(0, count(input)))

        let matched = matches.count > 0
        let captures = matches.map { match in
            return (1..<match.numberOfRanges).map { i in
                (input as NSString).substringWithRange(match.rangeAtIndex(i))
            } }.flatMap { $0 }

        return RegExMatch(matched: matched, captures: captures)
    } else {
        return RegExMatch(matched: false, captures: [])
    }
}

