// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class MessageWriterManagerSpec: QuickSpec {
    override func spec() {
        describe("MessageWriterManager") {
            it("returns PrintlnMessageWriter default instance") {
                expect(MessageWriterManager.defaultInstance is PrintlnMessageWriter).to(beTruthy())
            }
        }
    }
}