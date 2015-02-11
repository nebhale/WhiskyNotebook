// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


final class LogWriter {

    static let instance = LogWriter()

    typealias MessageProvider = () -> AnyObject

    private let dateFormatter: NSDateFormatter

    private let level: Level

    private let monitor = Monitor()

    private var maxNameLength = 0

    private init() {
        let config = configuration("Logging")

        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        self.dateFormatter.dateFormat = config?["Format"] as? String

        switch config?["Level"] as? String {
        case .Some("Debug"):
            self.level = Level.Debug
        case .Some("Info"):
            self.level = Level.Info
        case .Some("Warn"):
            self.level = Level.Warn
        case .Some("Error"):
            self.level = Level.Error
        default:
            self.level = Level.Warn
        }
    }

    func registerName(name: String) {
        synchronized(self.monitor) {
            self.maxNameLength = max(self.maxNameLength, count(name))
        }
    }

    func debug(name:String, @noescape messageProvider: MessageProvider) {
        log(Level.Debug) { "[DEBUG] \(self.pad(name)) \(messageProvider())" }
    }

    func info(name: String, @noescape messageProvider: MessageProvider) {
        log(Level.Info) { "[INFO]  \(self.pad(name)) \(messageProvider())" }
    }

    func warn(name: String, @noescape messageProvider: MessageProvider) {
        log(Level.Warn) { "[WARN]  \(self.pad(name)) \(messageProvider())" }
    }

    func error(name: String, @noescape messageProvider: MessageProvider) {
        log(Level.Error) { "[ERROR] \(self.pad(name)) \(messageProvider())" }
    }

    private func log(level: Level, @noescape messageProvider: MessageProvider) {
        synchronized(self.monitor) {
            if self.level.rawValue <= level.rawValue {
                println("\(self.dateFormatter.stringFromDate(NSDate())) \(messageProvider())")
            }
        }
    }

    private func pad(name: String) -> String {
        var padded = name

        while count(padded) < self.maxNameLength {
            padded += " "
        }

        return padded
    }

    private enum Level: Int {

        case Debug, Info, Warn, Error

    }

}
