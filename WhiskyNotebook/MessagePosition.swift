// Copyright 2014-2015 Ben Hale. All Rights Reserved

public struct MessagePosition {

    public let column: Int

    public let file: String

    public let function: String

    public let line: Int

    public init(column: Int, file: String, function: String, line: Int) {
        self.column = column
        self.file = file
        self.function = function
        self.line = line
    }
}

extension MessagePosition: Printable {
    public var description: String { return "<MessagePosition: column=\(self.column), file=\(self.file), function=\(self.function), line=\(self.line)>"}
}