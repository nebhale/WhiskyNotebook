// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class DefaultMessageFormatterSpec: QuickSpec {
    override func spec() {
        describe("DefaultMessageFormatter") {
            var configuration: WhiskyNotebook.Configuration!
            let level = Level.Debug
            let messageFormatter = DefaultMessageFormatter()
            let messagePosition = MessagePosition(column: 0, file: "test-file", function: "test-function", line: 1)
            let messageProvider: MessageProvider = { "test-message" }

            beforeEach {
                configuration = WhiskyNotebook.Configuration(name: "test-name")
            }

            it("expands %column") {
                configuration.format = "%column"
                expect(messageFormatter.format(configuration: configuration, level: level, messagePosition: messagePosition, messageProvider: messageProvider)).to(equal(String(messagePosition.column)))
            }

            it("expands %date{}") {
                configuration.format = "%date{HH:mm}"
                expect(messageFormatter.format(configuration: configuration, level: level, messagePosition: messagePosition, messageProvider: messageProvider) =~ "[\\d]{2}:[\\d]{2}").to(beTruthy())
            }

            it("expands %file") {
                configuration.format = "%file"
                expect(messageFormatter.format(configuration: configuration, level: level, messagePosition: messagePosition, messageProvider: messageProvider)).to(equal(messagePosition.file))
            }

            it("expands %function") {
                configuration.format = "%function"
                expect(messageFormatter.format(configuration: configuration, level: level, messagePosition: messagePosition, messageProvider: messageProvider)).to(equal(messagePosition.function))
            }

            it("expands %level") {
                configuration.format = "%level"
                expect(messageFormatter.format(configuration: configuration, level: .Debug, messagePosition: messagePosition, messageProvider: messageProvider)).to(equal("DEBUG"))
                expect(messageFormatter.format(configuration: configuration, level: .Info,  messagePosition: messagePosition, messageProvider: messageProvider)).to(equal("INFO "))
                expect(messageFormatter.format(configuration: configuration, level: .Warn,  messagePosition: messagePosition, messageProvider: messageProvider)).to(equal("WARN "))
                expect(messageFormatter.format(configuration: configuration, level: .Error, messagePosition: messagePosition, messageProvider: messageProvider)).to(equal("ERROR"))
            }

            it("expands %line") {
                configuration.format = "%line"
                expect(messageFormatter.format(configuration: configuration, level: level, messagePosition: messagePosition, messageProvider: messageProvider)).to(equal(String(messagePosition.line)))
            }

            it("expands %message") {
                configuration.format = "%message"
                expect(messageFormatter.format(configuration: configuration, level: level, messagePosition: messagePosition, messageProvider: messageProvider)).to(equal(messageProvider() as? String))
            }
        }
    }
}