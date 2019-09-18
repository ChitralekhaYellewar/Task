//
//  TagsListProtocols.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import Foundation

import UIKit

//TagsListPresenter to TagsListView
protocol TagsListViewInterface: class {
    //things to be done by view.
    func reloadTagsData()
    func setInitialTitle(with title:String)
    func setSegmentControl()
}

//
protocol TagsListPresenterInterface: class {
    //TagsView To TagsListPresenter
    
    func notifyTagsViewLoaded(for index: IndexPath)
    func notifyViewWillAppear()
    func notifySegmentChanged(index: Int)
    
    //TagsListInteractor to TagsListPresenter
    
    func tagsListFetched(TagsList: [String], selectedIndex: IndexPath)
    
    func tagsListFetchedFailed(with errorMsg: String)
    
    func mappingSetsFetched(list: [MappingSets])
    
    func getMappingSets() -> [mappingSetModel]? 
    
    func getTagsViewModel() -> [String]?
    
    var selectedIndex: IndexPath? { get set }
    
}

protocol TagsListRouterInterface: class {
    //TagsListPresenter to TagsListRouter
}

protocol TagsListInteractorInterface: class {
    
    func fetchTagsList(for segmentIndex: Int,for selectedArticleIndex: IndexPath)
    func fetchMappingSets(for selectedIndex: IndexPath)
    
    func segmentSelected(for index: IndexPath, segmentIndex: Int)
}
