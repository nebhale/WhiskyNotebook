// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa


public func signalingCompletionHandler<T>(sink: SinkOf<Event<T, NSError>>)(value: T!, error: NSError!) {
    if error != nil {
        sendError(sink, error)
    } else {
        sendNext(sink, value)
    }
}