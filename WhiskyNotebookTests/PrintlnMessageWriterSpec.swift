// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class PrintlnMessageWriterSpec: QuickSpec {
    override func spec() {
        class StubMessageFormatter: MessageFormatter {

            var called = false

            func format(#configuration: WhiskyNotebook.Configuration, level: Level, messagePosition: MessagePosition, @noescape messageProvider: MessageProvider) -> String? {
                self.called = true
                return nil
            }
        }

        var configuration = WhiskyNotebook.Configuration(name: "test-name")
        configuration.level = .Info
        var messageFormatter: StubMessageFormatter!
        let messagePosition = MessagePosition(column: 0, file: "test-file", function: "test-function", line: 1)
        var messageWriter: MessageWriter!

        beforeEach {
            messageFormatter = StubMessageFormatter()
            messageWriter = PrintlnMessageWriter(messageFormatter: messageFormatter)
        }

        it("does not print if log level is below configuration level") {
            messageWriter.write(configuration: configuration, level: Level.Debug, messagePosition: messagePosition, messageProvider: { "" })
            expect(messageFormatter.called).to(beFalsy())
        }

        it("prints if log level is equal to configuration level") {
            messageWriter.write(configuration: configuration, level: Level.Info, messagePosition: messagePosition, messageProvider: { "" })
            expect(messageFormatter.called).to(beTruthy())
        }

        it("prints if log level is above configuration level") {
            messageWriter.write(configuration: configuration, level: Level.Warn, messagePosition: messagePosition, messageProvider: { "" })
            expect(messageFormatter.called).to(beTruthy())
        }
    }
}