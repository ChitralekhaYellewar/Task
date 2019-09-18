//
//  MappingSets.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import CoreData
import ObjectMapper

struct MappingSets: Mappable {
    
    init?(map: Map) {
        id = Defaults.emptyString
        name = Defaults.emptyString
    }
    
    mutating func mapping(map: Map) {
        id <- map[coreDataConstants.UUID]
        name <- map[coreDataConstants.Name]
    }
    
    var id: String
    var name: String
    
    //MARK: - get Mapping Sets from managed object.
    static func getMappingSetsFrom(data: [NSManagedObject]) -> [MappingSets] {
        var mappingSet = [MappingSets]()
        
        for mappingSetsData in data {
            #if DEBUG
            print(mappingSetsData)
            #endif
            for item in [mappingSetsData] {
                var dict: [String: Any] = [:]
                for attribute in item.entity.attributesByName {
                    //check if value is present, then add key to dictionary so as to avoid the nil value crash
                    if let value = item.value(forKey: attribute.key) {
                        dict[attribute.key] = value
                    }
                    
                }
                guard let mappingSets = Mapper<MappingSets>().map(JSON: dict) else { return [] }
                mappingSet.append(mappingSets)
            }
        }
        print(mappingSet)
        
        return sortMappingSets(for: mappingSet)
    }
    
    static func sortMappingSets(for set: [MappingSets]) -> [MappingSets] {
        var sortedSet = [MappingSets]()
        sortedSet = set
        let element = sortedSet.remove(at: 0)
        sortedSet.append(element)
        return sortedSet
    }
}
