// Copyright 2014 Ben Hale. All Rights Reserved

enum Region: String, Comparable, Printable {
    
    case Bourbon = "BOURBON"
    
    case Campbeltown = "CAMPBELTOWN"
    
    case Grain = "GRAIN"
    
    case Highland = "HIGHLAND"
    
    case Ireland = "IRELAND"
    
    case Islay = "ISLAY"
    
    case Japan = "JAPAN"
    
    case Lowland = "LOWLAND"
    
    case Rum = "RUM"
    
    case Speyside = "SPEYSIDE"
    
    case Wales = "WALES"
    
    // MARK: Printable
    
    var description: String {
        get {
            return self.rawValue
        }
    }
    
}

// MARK: Comparable

func <(x: Region, y: Region) -> Bool {
    return x.rawValue < y.rawValue
}