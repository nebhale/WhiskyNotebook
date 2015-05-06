// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Nimble
import Quick
import UIKit

final class DistilleryCellSpec: QuickSpec {
    override func spec() {
        describe("DistilleryCell") {
            var cell: DistilleryCell!
            var id: UILabel!
            var name: UILabel!
            var region: UILabel!

            beforeEach {
                id = UILabel()
                name = UILabel()
                region = UILabel()

                cell = DistilleryCell()
                cell.id = id
                cell.name = name
                cell.region = region
            }

            describe("Interface Update") {
                it("configures id when nil") {
                    expect(id.text).to(beNil())
                    cell.configure(Distillery(id: nil, location: nil, name: nil, region: nil))
                    expect(id.text).to(beNil())
                }

                it("configures id when not nil") {
                    expect(id.text).to(beNil())
                    cell.configure(Distillery(id: "test-id", location: nil, name: nil, region: nil))
                    expect(id.text).to(equal("test-id"))
                }

                it("configures name when nil") {
                    expect(name.text).to(beNil())
                    cell.configure(Distillery(id: nil, location: nil, name: nil, region: nil))
                    expect(name.text).to(beNil())
                }

                it("configures name when not nil") {
                    expect(name.text).to(beNil())
                    cell.configure(Distillery(id: nil, location: nil, name: "test-name", region: nil))
                    expect(name.text).to(equal("test-name"))
                }

                it("configures region when nil") {
                    expect(region.text).to(beNil())
                    cell.configure(Distillery(id: nil, location: nil, name: nil, region: nil))
                    expect(region.text).to(beNil())
                }

                it("configures region when not nil") {
                    expect(region.text).to(beNil())
                    cell.configure(Distillery(id: nil, location: nil, name: nil, region: .Campbeltown))
                    expect(region.text).to(equal("Campbeltown"))
                }
            }
        }
    }
}
