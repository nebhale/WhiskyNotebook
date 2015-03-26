// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import WhiskyNotebook


final class BasenameSpec: QuickSpec {
    override func spec() {
        describe("basename()") {
            it("returns the file of a path") {
                expect("/path/file.extension".basename()).to(equal("file"))
            }
        }
    }
}