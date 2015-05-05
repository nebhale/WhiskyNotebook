// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick

final class SetOperatorsSpec: QuickSpec {
    override func spec() {
        describe("Set operators") {
            it("inserts member") {
                var set = Set<String>()
                expect(set).toNot(contain("test"))
                set + "test"
                expect(set).to(contain("test"))
            }

            it("removes member") {
                var set = Set<String>(arrayLiteral: "test")
                expect(set).to(contain("test"))
                set - "test"
                expect(set).toNot(contain("test"))
            }
        }
    }
}
