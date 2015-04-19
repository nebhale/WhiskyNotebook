// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class DramsImporterSpec: QuickSpec {
    override func spec() {
        let bundle = NSBundle(forClass: self.dynamicType)

        describe("DramsImporter") {
            var drams: Set<Dram>!
            var importer: DramsImporter!
            var repository: DramRepository!
            var scheduler: TestScheduler!

            var presented = false

            beforeEach {
                repository = InMemoryDramRepository()
                repository.drams
                    |> start { drams = $0 }

                scheduler = TestScheduler()

                let viewController = UIViewController()
                viewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                    |> start{ _ in presented = true }

                importer = DramsImporter()
                importer.repository = repository
                importer.scheduler = scheduler
                importer.viewController = viewController
            }

            describe("Import Action") {
                it("presents menu") {
                    importer.importDrams()
                    expect(presented).to(beTruthy())
                }
            }

            describe("Document Menu") {
                var documentMenu: UIDocumentMenuViewController!
                var documentPicker: UIDocumentPickerViewController!

                beforeEach {
                    documentMenu = UIDocumentMenuViewController()
                    documentPicker = UIDocumentPickerViewController()
                }

                it("assigns itself as delegate") {
                    importer.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                    expect(documentPicker.delegate === importer).to(beTruthy())
                }

                it("presents picker") {
                    importer.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                    expect(presented).to(beTruthy())
                }
            }

            describe("Document Picker") {
                it("imports distilleries") {
                    let url = bundle.URLForResource("Drams", withExtension: "csv")!

                    importer.documentPicker(UIDocumentPickerViewController(), didPickDocumentAtURL: url)
                    scheduler.advance()
                    
                    expect(drams.count).to(equal(3))
                }
            }
        }
    }
}