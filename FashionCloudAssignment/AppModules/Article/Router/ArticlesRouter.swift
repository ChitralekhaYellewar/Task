//
//  ArticlesRouter.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit

class ArticlesRouter {
    // create module
    weak var presenter: ArticlesListPresenterInterface?
    var navigationController: UINavigationController?


    static func createArticlesModule() -> ArticlesViewController {
        
        //create layers
        let router = ArticlesRouter()
        let presenter = ArticlesPresenter()
        let interactor = ArticlesInteractor()
        let view = UIStoryboard(name: StoryboardConstants.Main, bundle: nil).instantiateViewController(withIdentifier: StoryboardConstants.ArticlesView) as! ArticlesViewController
        
        //connect layers
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
        
    }
}

extension ArticlesRouter: ArticlesListRouterInterface {
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func performSegue(with identifier: String) {
        let _ = TagsListRouter.createTagsModule()
        self.navigationController?.visibleViewController?.performSegue(withIdentifier: identifier, sender: nil)
    }
    
    func presentPop(with message: String) {
        let alertController = UIAlertController(title: Defaults.Error, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Defaults.OK, style: .default, handler: nil))
        self.navigationController?.visibleViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func pushToTagsScreen(navigationController: UINavigationController, selectedIndex: IndexPath) {//, sortedTags: [String]) {

        let tagsModule = TagsListRouter.createTagsModule()
        
        tagsModule.presenter?.selectedIndex = selectedIndex
        
        navigationController.pushViewController(tagsModule,animated: true)
        
    }
    
}

