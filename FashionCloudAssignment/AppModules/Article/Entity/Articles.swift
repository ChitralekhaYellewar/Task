//
//  Articles.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import ObjectMapper
import CoreData

struct Articles: Mappable {
    
    var articlesID: String
    var articlesSortOrder: Float32
    var articlesName: String
    var articlesTags: [String]
    
    init?(map: Map) {
        articlesID = Defaults.emptyString
        articlesSortOrder = 0.0
        articlesName = Defaults.emptyString
        articlesTags = [ Defaults.emptyString ]
    }
    
    mutating func mapping(map: Map) {
        articlesID <- map[coreDataConstants.UUID]
        articlesSortOrder <- map[coreDataConstants.SortingOrder]
        articlesName <- map[coreDataConstants.Name]
        articlesTags <- map[coreDataConstants.Tags]
    }
    
    static func getArticlesFrom(data: [NSManagedObject]) -> [Articles] {
        var articles = [Articles]()

        for articleData in data {
            #if DEBUG
            print(articleData)
            #endif
            for item in [articleData] {
                var dict: [String: Any] = [:]
                for attribute in item.entity.attributesByName {
                    //check if value is present, then add key to dictionary so as to avoid the nil value crash
                    if let value = item.value(forKey: attribute.key) {
                        dict[attribute.key] = value
                    }
                }
                guard let article = Mapper<Articles>().map(JSON: dict) else { return [] }
                articles.append(article)
            }
        }
        print(articles)
        
        return articles
    }
}

