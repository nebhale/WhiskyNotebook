// Copyright 2014 Ben Hale. All Rights Reserved

final class NameSectionProjection<Void>: AbstractSectionProjection<String> {
    
    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    
    init(_ distilleries: [Distillery]) {
        super.init(distilleries, self.letters.map { Section("\($0)") })
    }
    
    convenience init(_ sectionProjection: SectionProjection) {
        self.init(sectionProjection.source())
    }
    
    override func key(distillery: Distillery) -> [String] {
        return [distillery.name[0]]
    }
    
    override func sectionIndexTitle(section: Section<String>) -> String? {
        return section.key
    }
    
    override func sectionTitle(section: Section<String>) -> String? {
        return section.key
    }
    
}