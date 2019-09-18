//
//  TagsListRouter.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit

class TagsListRouter {
    
    weak var presenter: TagsListPresenterInterface?
    
    static func createTagsModule() -> TagsListViewController {
        //create layers
        let router = TagsListRouter()
        let presenter = TagsListPresenter()
        let interactor = TagsListInteractor()
        let view = UIStoryboard(name: StoryboardConstants.Main, bundle: nil).instantiateViewController(withIdentifier: StoryboardConstants.TagsView) as! TagsListViewController
        
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

extension TagsListRouter: TagsListRouterInterface {
    
}
