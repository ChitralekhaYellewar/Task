//
//  TagsListEntity.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import ObjectMapper
import CoreData

struct Tags: Mappable {
    
    var tagsId: String
    var sortOrder: Int
    var sourceTags: String
    var destinationValue: String
    
    init?(map: Map) {
        tagsId = Defaults.emptyString
        sortOrder = 0
        sourceTags = Defaults.emptyString
        destinationValue = Defaults.emptyString
    }
    
    mutating func mapping(map: Map) {
        tagsId <- map[coreDataConstants.UUID]
        sortOrder <- map[coreDataConstants.SortingOrder]
        sourceTags <- map[coreDataConstants.SourceTags]
        destinationValue <- map[coreDataConstants.DestinationValue]
    }
    
    //MARK: - get Mapping Sets from managed object.
    static func getTagsFrom(data: [NSManagedObject]) -> [Tags] {
        var tags = [Tags]()
        
        for tagsData in data {
            #if DEBUG
            print(tagsData)
            #endif
            for item in [tagsData] {
                var dict: [String: Any] = [:]
                for attribute in item.entity.attributesByName {
                    //check if value is present.
                    if let value = item.value(forKey: attribute.key) {
                        dict[attribute.key] = value
                    }
                    
                }
                guard let tag = Mapper<Tags>().map(JSON: dict) else { return [] }
                tags.append(tag)
            }
        }
        print(tags)
        
        return tags
    }
}

