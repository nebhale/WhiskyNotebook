// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import Nimble
import Quick
import ReactiveCocoa
import UIKit

final class DramCSVImporterSpec: QuickSpec {
    override func spec() {
        describe("DramCSVImporter") {
            var importer: DramCSVImporter!
            var repository: DramRepository!
            var rootViewController: UIViewController!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDramRepository()
                rootViewController = UIViewController()
                scheduler = TestScheduler()

                importer = DramCSVImporter(repository: repository, scheduler: scheduler, viewController: rootViewController)
            }

            context("action") {
                var presentedDocumentMenu: UIDocumentMenuViewController?

                beforeEach {
                    rootViewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                        |> map { $0 as? RACTuple }
                        |> map { $0?.first as? UIDocumentMenuViewController }
                        |> filter { $0 != nil }
                        |> start{ presentedDocumentMenu = $0 }

                    importer.importDrams()
                    scheduler.advance()
                }

                it("presents document menu") {
                    expect(presentedDocumentMenu).toNot(beNil())
                }

                context("document menu delegate") {
                    var documentMenu: UIDocumentMenuViewController!
                    var documentPicker: UIDocumentPickerViewController!
                    var presentedDocumentPicker: UIDocumentPickerViewController?

                    beforeEach {
                        documentMenu = UIDocumentMenuViewController()
                        documentPicker = UIDocumentPickerViewController()

                        rootViewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                            |> map { $0 as? RACTuple }
                            |> map { $0?.first as? UIDocumentPickerViewController }
                            |> filter { $0 != nil }
                            |> start{ presentedDocumentPicker = $0 }

                        presentedDocumentMenu?.delegate?.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                    }

                    it("presents document picker") {
                        expect(presentedDocumentPicker).toNot(beNil())
                    }

                    context("document picker delegate") {
                        it("imports distilleries") {
                            let url = NSBundle(forClass: self.dynamicType).URLForResource("Drams", withExtension: "csv")!
                            presentedDocumentPicker?.delegate?.documentPicker(documentPicker, didPickDocumentAtURL: url)
                                                scheduler.advance()
                            
                            expect(repository.drams.value.count).to(equal(3))
                        }
                    }
                }
            }
        }
    }
}
