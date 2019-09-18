//
//  ArticlesPresenter.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit

typealias ArticlesViewModel = (id: String, sortOrder: Float32, name: String, tags: [String])

class ArticlesPresenter {
    
    weak var view: ArticlesListViewInterface?
    var interactor: ArticlesListInteractorInterface?
    var router : ArticlesListRouterInterface?
    
    var articlesViewModels = [ArticlesViewModel]()
    
    let coreDataManager = CoreDataManager()
    
    
}

extension ArticlesPresenter : ArticlesListPresenterInterface {
    
    
    func articlesListFetched(articlesList: [Articles]) {
        var articlesViewModels = [ArticlesViewModel]()
        
        for article in articlesList {
            let articlesViewModel: ArticlesViewModel = (id: article.articlesID, sortOrder: article.articlesSortOrder, name: article.articlesName, tags: article.articlesTags)
            
                articlesViewModels.append(articlesViewModel)
        }
        self.articlesViewModels = articlesViewModels
        view?.reloadData()
    }
    
    func notifyViewLoaded() {
        // and interactor to fetch data.
        interactor?.fetchArticlesList()
        
    }
    
    func notifyViewWillAppear() {
        view?.setInitialTitle(with: StoryboardConstants.PageTitle)
    }
    
    func addNewArticlesTapped() {
        router?.performSegue(with: StoryboardConstants.ArticlesDetailSegueIdentifier)
    }
    
    func articlesSelected(navigationController: UINavigationController, forIndexPath: IndexPath, segment: Int) {
        router?.pushToTagsScreen(navigationController: navigationController, selectedIndex: forIndexPath)
    }
    
    func articlesListFetchedFailed(with errorMsg: String) {
        router?.presentPop(with: errorMsg)
    }
    
    func getArticlesViewModel() -> [ArticlesViewModel]? {
        return articlesViewModels
    }
}
