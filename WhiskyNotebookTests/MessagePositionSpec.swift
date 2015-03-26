// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class MessagePositionSpec: QuickSpec {
    override func spec() {
        describe("MessagePosition") {
            it("initializes all properties to values") {
                let messagePosition = MessagePosition(column: 0, file: "test-file", function: "test-function", line: 1)
                expect(messagePosition.column).to(equal(0))
                expect(messagePosition.file).to(equal("test-file"))
                expect(messagePosition.function).to(equal("test-function"))
                expect(messagePosition.line).to(equal(1))
            }
        }
    }
}