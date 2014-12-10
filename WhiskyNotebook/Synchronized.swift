// Copyright 2014 Ben Hale. All Rights Reserved

import Foundation

final class Monitor {}

func synchronized<T>(monitor: Monitor, closure: () -> T) -> T {
    var result: T
    
    objc_sync_enter(monitor)
    result = closure()
    objc_sync_exit(monitor)
    
    return result
}

func synchronized(monitor: Monitor, closure: () -> Void) {
    objc_sync_enter(monitor)
    closure()
    objc_sync_exit(monitor)
}