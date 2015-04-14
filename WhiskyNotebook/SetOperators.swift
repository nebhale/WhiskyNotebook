// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation

public func +<T>(inout set: Set<T>, member: T) {
    set.insert(member)
}

public func -<T>(inout set: Set<T>, member: T) {
    set.remove(member)
}