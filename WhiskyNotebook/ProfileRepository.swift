// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import ReactiveCocoa


protocol ProfileRepository {
    var profile: PropertyOf<Profile> { get }
}