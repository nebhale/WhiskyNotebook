// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import WhiskyNotebook


final class SingalingCompletionHandlerSpec: QuickSpec {
    override func spec() {
        describe("singalingCompletionHandler()") {
            var signal: Signal<Int, NSError>!
            var handler: ((value: Int!, error: NSError!) ->())!

            beforeEach {
                signal = Signal { sink in
                    handler = signalingCompletionHandler(sink)
                    return nil
                }
            }

            it("signals an error") {
                var error: NSError?
                signal
                    |> observe(error: { error = $0 })

                expect(error).to(beNil())
                handler(value: nil, error: NSError(domain: "test", code: -1, userInfo: [:]))
                expect(error).toNot(beNil())
            }

            it("signals a value") {
                var value: Int?
                signal
                    |> observe { value = $0 }

                expect(value).to(beNil())
                handler(value: 1, error: nil)
                expect(value).toNot(beNil())
            }
        }
    }
}