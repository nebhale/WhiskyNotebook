// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


final class Monitor {}

func synchronized<T>(monitor: Monitor, f: () -> T) -> T {
    var result: T

    objc_sync_enter(monitor)
    result = f()
    objc_sync_exit(monitor)

    return result
}

func synchronized(monitor: Monitor, f: () -> Void) {
    objc_sync_enter(monitor)
    f()
    objc_sync_exit(monitor)
}
