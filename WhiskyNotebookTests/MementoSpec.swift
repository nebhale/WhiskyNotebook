// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation
import Quick
import Nimble
import WhiskyNotebook

class MementoSpec: QuickSpec {

    override func spec() {
        describe("Memento") {

            let id = NSUUID()
            let memento1 = Memento(id: id)
            let memento2 = Memento(id: id)

            it("is Hashable") {
                expect(memento1.hashValue).to(equal(memento2.hashValue))
            }

            it("is Equatable") {
                expect(memento1).to(equal(memento2))
            }

        }
    }

}
