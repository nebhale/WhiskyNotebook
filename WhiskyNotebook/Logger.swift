// Copyright 2014-2015 Ben Hale. All Rights Reserved


public final class Logger {

    private let configuration: Configuration

    private let messageWriter: MessageWriter

    public init(name: String = __FILE__, configurationProvider: ConfigurationProvider = ConfigurationProviderManager.defaultInstance, messageWriter: MessageWriter = MessageWriterManager.defaultInstance) {
        self.configuration = configurationProvider.configuration(name.basename())
        self.messageWriter = messageWriter
    }

    public func debug(@autoclosure messageProvider: MessageProvider, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Debug, messagePosition: messagePosition, messageProvider: messageProvider)
    }

    public func debug(file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__, messageProvider: MessageProvider) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Debug, messagePosition: messagePosition, messageProvider: messageProvider)
    }

    public func info(@autoclosure messageProvider: MessageProvider, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Info, messagePosition: messagePosition, messageProvider: messageProvider)
    }

    public func info(file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__, messageProvider: MessageProvider) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Info, messagePosition: messagePosition, messageProvider: messageProvider)
    }

    public func warn(@autoclosure messageProvider: MessageProvider, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Warn, messagePosition: messagePosition, messageProvider: messageProvider)
    }

    public func warn(file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__, messageProvider: MessageProvider) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Warn, messagePosition: messagePosition, messageProvider: messageProvider)
    }

    public func error(@autoclosure messageProvider: MessageProvider, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Error, messagePosition: messagePosition, messageProvider: messageProvider)
    }

    public func error(file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__, messageProvider: MessageProvider) {
        let messagePosition = MessagePosition(column: column, file: file, function: function, line: line)
        self.messageWriter.write(configuration: self.configuration, level: .Error, messagePosition: messagePosition, messageProvider: messageProvider)
    }
}