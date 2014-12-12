// Copyright 2014 Ben Hale. All Rights Reserved

final class RegionSectionProjection<Void>: AbstractSectionProjection<Distillery.Region> {
    
    init(_ distilleries: [Distillery]) {
        super.init(distilleries, [])
    }
    
    convenience init(_ sectionProjection: SectionProjection) {
        self.init(sectionProjection.source())
    }
    
    override func key(distillery: Distillery) -> [Distillery.Region] {
        return [distillery.region]
    }
    
    override func sectionIndexTitle(section: Section<Distillery.Region>) -> String? {
        return nil
    }
    
    override func sectionTitle(section: Section<Distillery.Region>) -> String? {
        return section.key.rawValue
    }
    
}