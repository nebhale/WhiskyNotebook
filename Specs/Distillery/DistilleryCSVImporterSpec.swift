// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import Nimble
import Quick
import ReactiveCocoa
import UIKit

final class DistilleryCSVImporterSpec: QuickSpec {
    override func spec() {
        describe("DistilleryCSVImporter") {
            var importer: DistilleryCSVImporter!
            var repository: DistilleryRepository!
            var rootViewController: UIViewController!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDistilleryRepository()
                rootViewController = UIViewController()
                scheduler = TestScheduler()

                importer = DistilleryCSVImporter(repository: repository, scheduler: scheduler, viewController: rootViewController)
            }

            context("action") {
                var presentedDocumentMenu: UIDocumentMenuViewController?

                beforeEach {
                    rootViewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                        |> map { $0 as? RACTuple }
                        |> map { $0?.first as? UIDocumentMenuViewController }
                        |> filter { $0 != nil }
                        |> start{ presentedDocumentMenu = $0 }

                    importer.importDistilleries()
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
                            let url = NSBundle(forClass: self.dynamicType).URLForResource("Distilleries", withExtension: "csv")!
                            presentedDocumentPicker?.delegate?.documentPicker(documentPicker, didPickDocumentAtURL: url)
                            scheduler.advance()

                            expect(repository.distilleries.value.count).to(equal(3))
                        }
                    }
                }
            }
        }
    }
}
