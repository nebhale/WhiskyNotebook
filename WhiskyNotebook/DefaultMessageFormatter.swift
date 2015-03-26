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
            .replace("%thread", with: thread())
    }

    private func dateFormatter() -> ReplacementGenerator {
        return { captures in
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = captures[1]

            return dateFormatter.stringFromDate(NSDate())
        }
    }

    private func thread() -> String {
        return NSThread.isMainThread() ? "Main" : "Background"
    }

}

// MARK: - Level Logging
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

// MARK - Pattern Replacement
public typealias ReplacementGenerator = [String] -> AnyObject

extension String {
    public func replace(pattern: String, @autoclosure with replacement: () -> AnyObject) -> String {
        return replace(pattern, with: { regex in replacement() })
    }

    public func replace(pattern: String, @noescape with replacement: ReplacementGenerator) -> String {
        let captures = self.matches(pattern)?.map { match -> [String] in
            return (0..<match.numberOfRanges).map { i -> String in
                let range = match.rangeAtIndex(i)
                return self[range.location..(range.location + range.length)]!
            }
            }.flatMap { $0 }

        if captures?.count > 0 {
            return self.stringByReplacingOccurrencesOfString(pattern, withString: "\(replacement(captures!))", options: .RegularExpressionSearch, range: nil)
        } else {
            return self
        }
    }
    
}
