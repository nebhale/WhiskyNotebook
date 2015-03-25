// Copyright 2014-2015 Ben Hale. All Rights Reserved

public final class PrintlnMessageWriter: MessageWriter {

    private let messageFormatter: MessageFormatter

    public init(messageFormatter: MessageFormatter = DefaultMessageFormatter()) {
        self.messageFormatter = messageFormatter
    }

    public func write(#configuration: Configuration, level: Level, messagePosition: MessagePosition, @noescape messageProvider: MessageProvider) {
        if configuration.level.rawValue <= level.rawValue {
            if let message = self.messageFormatter.format(configuration: configuration, level: level, messagePosition: messagePosition, messageProvider: messageProvider) {
                println(message)
            }
        }
    }

}