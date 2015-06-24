// Copyright 2014-2015 Ben Hale.  All Rights Reserved.


struct IMProfile: Profile {

    var administrator: Bool?

    var membership: String?
}

// MARK: CustomStringConvertible
extension IMProfile: CustomStringConvertible {
    var description: String { return "<IMProfile: administrator=\(self.administrator), membership=\(self.membership)>" }
}