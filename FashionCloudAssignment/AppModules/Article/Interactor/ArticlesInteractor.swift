//
//  ArticlesInteractor.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import Foundation

class ArticlesInteractor {
    
    let service = ArticlesService()
    
    weak var presenter: ArticlesListPresenterInterface?
    
    let coreDataManager = CoreDataManager()
    
}

extension ArticlesInteractor: ArticlesListInteractorInterface {
    
    func articleSelected(for index: IndexPath, in selectedMappingId: Int, segment: Int) -> [String] {
        
        guard let selectedArticle = coreDataManager.getArticlesData(),
            let selectedMappingSet = coreDataManager.getMappingSetsData(),
            let tagsForMappingSet = coreDataManager.getTagsData() else { return [] }
        
        let tagsOfArticle = selectedArticle[index.row].articlesTags
        _ = selectedMappingSet[index.row].id
        
        var sourceTagsToShow = [String]()
        
        for sourceTag in tagsOfArticle {
            for tag in tagsForMappingSet {
                if sourceTag == tag.sourceTags {
                    #if DEBUG
                    print(sourceTag)
                    #endif
                    sourceTagsToShow.append(tag.destinationValue)
                }
            }
        }
        return sourceTagsToShow
    }
    
    
    func fetchArticlesList() {
        //check if core data is empty.
        guard let articleList = coreDataManager.getArticlesData() else { return }
    
        if articleList.count == 0 {
            
            service.fetchArticles(with: { [weak self] (articles) in
                
                guard let articleList = articles else { return }
                
                self?.coreDataManager.deleteAllData(for: coreDataConstants.ArticlesData)
                self?.coreDataManager.saveArticles(data: articleList)
                
                self?.presenter?.articlesListFetched(articlesList: articleList)
                
                }, failure: { [weak self] (errorMsg) in
                    guard let error = errorMsg else { return }
                    self?.presenter?.articlesListFetchedFailed(with: error.localizedDescription)
                    
            })
        } else {
            self.presenter?.articlesListFetched(articlesList: articleList)
        }
        
    }

}
