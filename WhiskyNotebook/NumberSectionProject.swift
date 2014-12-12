// Copyright 2014 Ben Hale. All Rights Reserved

final class NumberSectionProjection<Void>: AbstractSectionProjection<String> {
    
    let interval = 10
    
    init(_ distilleries: [Distillery]) {
        super.init(distilleries, [Section("B"), Section("G"), Section("R")])
    }
    
    convenience init(_ sectionProjection: SectionProjection) {
        self.init(sectionProjection.source())
    }
    
    override func key(distillery: Distillery) -> [String] {
        switch distillery.region {
        case .Bourbon:
            return ["B"]
        case .Grain:
            return ["G"]
        case .Rum:
            return ["R"]
        default:
            if let id = distillery.id.toInt() {
                return [String(id - (id % self.interval))]
            } else {
                return ["#"]
            }
        }
    }
    
    override func sectionIndexTitle(section: Section<String>) -> String? {
        return section.key == "0" ? "1" : section.key
    }
    
    override func sectionTitle(section: Section<String>) -> String? {
        return nil
    }

}
