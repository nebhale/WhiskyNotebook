// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class LoggerSpec: QuickSpec {
    override func spec() {
        class StubConfigurationProvider: ConfigurationProvider {
            private func configuration(name: String) -> WhiskyNotebook.Configuration {
                return WhiskyNotebook.Configuration(name: name)
            }
        }

        class StubMessageWriter: MessageWriter {

            var configuration: WhiskyNotebook.Configuration?

            var level: Level?

            var messagePosition: MessagePosition?

            var message: String?

            private func write(#configuration: WhiskyNotebook.Configuration, level: Level, messagePosition: MessagePosition, @noescape messageProvider: MessageProvider) {
                self.configuration = configuration
                self.level = level
                self.messagePosition = messagePosition
                self.message = messageProvider() as? String
            }
        }

        describe("Logger") {
            var configurationProvider: StubConfigurationProvider!
            var messageWriter: StubMessageWriter!
            var logger: Logger!

            beforeEach {
                configurationProvider = StubConfigurationProvider()
                messageWriter = StubMessageWriter()
                logger = Logger(name: "test-name", configurationProvider: configurationProvider, messageWriter: messageWriter)
            }

            it("uses caller's file as a default logger name") {
                Logger(configurationProvider: configurationProvider, messageWriter: messageWriter).debug("test-message")
                expect(messageWriter.configuration).to(equal(Configuration(name: "LoggerSpec")))
            }

            it("writes a debug message with an autoclosure") {
                logger.debug("test-message")
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Debug))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }

            it("writes a debug messages with a closure") {
                logger.debug { "test-message" }
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Debug))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }

            it("writes a info message with an autoclosure") {
                logger.info("test-message")
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Info))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }

            it("writes a info messages with a closure") {
                logger.info { "test-message" }
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Info))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }

            it("writes a warn message with an autoclosure") {
                logger.warn("test-message")
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Warn))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }

            it("writes a warn messages with a closure") {
                logger.warn { "test-message" }
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Warn))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }

            it("writes a error message with an autoclosure") {
                logger.error("test-message")
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Error))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }

            it("writes a error messages with a closure") {
                logger.error { "test-message" }
                expect(messageWriter.configuration).to(equal(Configuration(name: "test-name")))
                expect(messageWriter.level).to(equal(Level.Error))
                expect(messageWriter.messagePosition).toNot(beNil())
                expect(messageWriter.message).to(equal("test-message"))
            }
        }
    }
}