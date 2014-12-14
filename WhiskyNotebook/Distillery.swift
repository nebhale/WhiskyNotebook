// Copyright 2014 Ben Hale. All Rights Reserved

final class Distillery: Comparable, Equatable, Hashable, Printable {

    let id: String
    
    let name: String
    
    let region: Region
    
    let latitude: Double
    
    let longitude: Double
    
    init(_ id:String, _ name: String, _ region: Region, _ latitude: Double, _ longitude: Double) {
        self.id = id
        self.name = name
        self.region = region
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    var description: String {
        get {
            return "Distillery \(self.id)"
        }
    }
    
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
        
        var description: String {
            get {
                return self.rawValue
            }
        }
        
    }
}

func ==(x: Distillery, y: Distillery) -> Bool {
    return x.id == y.id
}

func <(x: Distillery, y: Distillery) -> Bool {
    var xType: Int, xId: Int
    if x.region == Distillery.Region.Bourbon || x.region == Distillery.Region.Grain || x.region == Distillery.Region.Rum {
        xType = x.region.hashValue
        xId = x.id.substringFromIndex(advance(x.id.startIndex,1)).toInt()!
    } else {
        xType = -1
        xId = x.id.toInt()!
    }
    
    var yType: Int, yId: Int
    if y.region == Distillery.Region.Bourbon || y.region == Distillery.Region.Grain || y.region == Distillery.Region.Rum {
        yType = y.region.hashValue
        yId = y.id.substringFromIndex(advance(y.id.startIndex,1)).toInt()!
    } else {
        yType = -1
        yId = y.id.toInt()!
    }
    
    if xType != yType {
        return xType < yType
    }
    
    return xId < yId
}

func <(x: Distillery.Region, y: Distillery.Region) -> Bool {
    return x.rawValue < y.rawValue
}