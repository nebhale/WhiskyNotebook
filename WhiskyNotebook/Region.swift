// Copyright 2014-2015 Ben Hale. All Rights Reserved


enum Region: String {
    case Campbeltown = "Campbeltown"
    case Grain       = "Grain"
    case Highland    = "Highland"
    case Ireland     = "Ireland"
    case Islay       = "Islay"
    case Japan       = "Japan"
    case Lowland     = "Lowland"
    case Speyside    = "Speyside"
    case Wales       = "Wales"
}

// MARK - Printable
extension Region: Printable {
    var description: String { return "<Region: \(self.rawValue)>" }
}