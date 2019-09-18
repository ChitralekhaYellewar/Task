//
//  TagsListService.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import ObjectMapper

class TagsListService {
    typealias completionHandler = ([Tags]?) -> Void
    typealias failureHandler = (Error?) -> Void
    
    typealias mappingCompletionHandler = ([MappingSets]?) -> Void
    
    //MARK: - fetch tags service
    func fetchTagsMapping(for endPoint: String,with completion: @escaping completionHandler, failure: failureHandler) {
        let tagsUrl = "\(URLs.MappingSetsURL)\(endPoint)" + "/mappings"
        ServiceHandler.request(endPoint: tagsUrl, requestMethod: RequestMethods.get, requestParameters: nil, httpHeaders: nil, completionHandler: { response in
            
            guard let tagsResponse = response as? [[String: Any]] else {
                completion(nil)
                return }
            
            let tagsList = Mapper<Tags>().mapArray(JSONArray: tagsResponse)
            completion(tagsList)
            
        }, failureHandler: { _ in })
    }
    
    //MARK: - fetch Mappable sets
    func fetchMappableSets(completion: @escaping mappingCompletionHandler, failure: failureHandler) {
        ServiceHandler.request(endPoint: URLs.MappingSetsURL, requestMethod: RequestMethods.get, requestParameters: nil, httpHeaders: nil, completionHandler: { response in
            guard let mappingSetsResponse = response as? [[String: Any]] else {
                completion(nil)
                return
            }
            
            let mappingSets = Mapper<MappingSets>().mapArray(JSONArray: mappingSetsResponse)
            completion(mappingSets)
        }, failureHandler: { _ in })
    }
}

