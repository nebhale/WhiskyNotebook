// Copyright 2014 Ben Hale. All Rights Reserved

final class Distillery: Comparable, Equatable, Hashable, Printable {
    
    // MARK: Properties

    let id: String
    
    let name: String
    
    let region: Region
    
    let latitude: Double
    
    let longitude: Double
    
    // MARK: Initialiezrs
    
    init(_ id:String, _ name: String, _ region: Region, _ latitude: Double, _ longitude: Double) {
        self.id = id
        self.name = name
        self.region = region
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: Hashable
    
    var hashValue: Int {
        return id.hashValue
    }
    
    // MARK: Printable
    
    var description: String {
        get { return "Distillery \(self.id)" }
    }
}

// MARK: Equatable

func ==(x: Distillery, y: Distillery) -> Bool {
    return x.id == y.id
}

// MARK: Comparable

func <(x: Distillery, y: Distillery) -> Bool {
    var xType: Int, xId: Int
    if x.region == Region.Bourbon || x.region == Region.Grain || x.region == Region.Rum {
        xType = x.region.hashValue
        xId = x.id.substringFromIndex(advance(x.id.startIndex,1)).toInt()!
    } else {
        xType = -1
        xId = x.id.toInt()!
    }
    
    var yType: Int, yId: Int
    if y.region == Region.Bourbon || y.region == Region.Grain || y.region == Region.Rum {
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