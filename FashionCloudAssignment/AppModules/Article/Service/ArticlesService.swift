//
//  ArticlesService.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import ObjectMapper

class ArticlesService {
    
    typealias completionHandler = ([Articles]?) -> Void
    typealias failureHandler = (Error?) -> Void
    
    //MARK: - fetch article service
    func fetchArticles(with completion: @escaping completionHandler, failure: failureHandler) {
        
        ServiceHandler.request(endPoint: URLs.ArticleURL, requestMethod: RequestMethods.get, requestParameters: nil, httpHeaders: nil, completionHandler: {  (response) in
            
            guard let articlesResponse = response as? [[String: Any]] else {
                completion(nil)
                return }
            
            let articlesList = Mapper<Articles>().mapArray(JSONArray: articlesResponse)
            completion(articlesList)
            
            }, failureHandler: { _ in })
    }
}
