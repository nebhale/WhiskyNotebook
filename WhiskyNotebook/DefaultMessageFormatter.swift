// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


public final class DefaultMessageFormatter: MessageFormatter {

    public init() {}

    public func format(#configuration: Configuration, level: Level, messagePosition: MessagePosition, @noescape messageProvider: MessageProvider) -> String? {
        return configuration.format
            .replace("%column", with: messagePosition.column)
            .replace("%date\\{(.+?)\\}", with: dateFormatter())
            .replace("%file", with: messagePosition.file.basename())
            .replace("%function", with: messagePosition.function)
            .replace("%level", with: level.toLoggingString())
            .replace("%line", with: messagePosition.line)
            .replace("%message", with: messageProvider())
    }
    
    private func dateFormatter() -> ReplacementGenerator {
        return { captures in
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = captures[0]

            return dateFormatter.stringFromDate(NSDate())
        }
    }
    
}

extension Level {
    public func toLoggingString() -> String {
        return pad(self.toString().uppercaseString, size: 5)
    }
    
    private func pad(value: String, size: Int) -> String {
        var padded = value
        while count(padded) < size { padded += " " }
        return padded
    }
}

public typealias ReplacementGenerator = [String] -> AnyObject

extension String {
    public func replace(pattern: String, @autoclosure with replacement: () -> AnyObject) -> String {
        return replace(pattern, with: { regex in replacement() })
    }
    
    public func replace(pattern: String, @noescape with replacement: ReplacementGenerator) -> String {
        let match: RegExMatch = self =~ pattern

        if match.matched {
            return self.stringByReplacingOccurrencesOfString(pattern, withString: "\(replacement(match.captures))", options: .RegularExpressionSearch, range: nil)
        } else {
            return self
        }
    }

    private func extractCaptures(string: String, matches: [NSTextCheckingResult]) -> [String] {
        return matches.map { match in
            return (self as NSString).substringWithRange(match.rangeAtIndex(1))
        }
    }
}