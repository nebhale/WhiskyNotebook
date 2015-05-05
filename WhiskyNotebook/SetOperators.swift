// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation

func +<T>(inout set: Set<T>, member: T) {
    set.insert(member)
}

func -<T>(inout set: Set<T>, member: T) {
    set.remove(member)
}