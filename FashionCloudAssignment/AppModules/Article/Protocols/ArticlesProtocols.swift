//
//  ArticlesProtocols.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit

//ArticlesListPresenter to ArticlesListView
protocol ArticlesListViewInterface: class {
    //things to be done by view.
    func reloadData()
    func setInitialTitle(with title:String)
}

//
protocol ArticlesListPresenterInterface: class {
    //ArticlesView To ArticlesListPresenter
    
    func notifyViewLoaded()
    func notifyViewWillAppear()
    func addNewArticlesTapped()
    func articlesSelected(navigationController: UINavigationController, forIndexPath: IndexPath, segment: Int) 
    
    //ArticlesListInteractor to ArticlesListPresenter
    func articlesListFetched(articlesList: [Articles])
    func articlesListFetchedFailed(with errorMsg: String)
    
    func getArticlesViewModel() -> [ArticlesViewModel]?
    
    
}

protocol ArticlesListRouterInterface: class {
    //ArticlesListPresenter to ArticlesListRouter
    
    func popBack()
    func performSegue(with identifier: String)
    func presentPop(with message: String)
    
    //func pushToTagsScreen(navigationController: UINavigationController)
    func pushToTagsScreen(navigationController: UINavigationController, selectedIndex: IndexPath)//, sortedTags: [String])
}

protocol ArticlesListInteractorInterface: class {
    // ArticlesListPresenter to ArticlesListInteractor
    func fetchArticlesList()
    func articleSelected(for index: IndexPath, in selectedMappingId: Int, segment: Int) -> [String]
}
