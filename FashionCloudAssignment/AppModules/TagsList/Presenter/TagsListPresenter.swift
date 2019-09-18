//
//  TagsListPresenter.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import Foundation

typealias TagsViewModel = (id: String, sortOrder: Int, sourceTags: String, destinationValue: String)
typealias mappingSetModel = (id: String, name: String)

class TagsListPresenter {
    
    weak var view: TagsListViewInterface?
    var interactor: TagsListInteractorInterface?
    var router : TagsListRouterInterface?
    
    var tagsViewModelss = [TagsViewModel]()
    var tagsViewModels = [String]()
    var mappingViewModels = [mappingSetModel]()
    
    var selectedIndex: IndexPath?
}

extension TagsListPresenter: TagsListPresenterInterface {
    
    func mappingSetsFetched(list: [MappingSets]) {
        var mappingSets = [mappingSetModel]()
        for set in list {
            let mappingSet: mappingSetModel = (id: set.id, name: set.name)
            mappingSets.append(mappingSet)
        }
        self.mappingViewModels = mappingSets
        view?.setSegmentControl()
    }
    
    func getMappingSets() -> [mappingSetModel]? {
        return mappingViewModels
    }
    
    //MARK: - fetch mapping on segment control change
    func notifySegmentChanged(index: Int) {
        
        guard let selectedArticleIndex = selectedIndex else { return }
        
        interactor?.segmentSelected(for: selectedArticleIndex, segmentIndex: index)
    }
    
    func getTagsViewModel() -> [String]? {
        return tagsViewModels
    }
    
    func notifyTagsViewLoaded(for index: IndexPath) {
        // and interactor to fetch data.
        interactor?.fetchMappingSets(for: index)
    }
    
    func notifyViewWillAppear() {
        view?.setInitialTitle(with: "")
    }
    
    
    func tagsListFetched(TagsList: [String], selectedIndex: IndexPath) {
        
        var tagsViewModels = [String]()
        for tags in TagsList {
            tagsViewModels.append(tags)
        }
        self.tagsViewModels = tagsViewModels
        self.selectedIndex = selectedIndex
        view?.reloadTagsData()
    }
    
    func tagsListFetchedFailed(with errorMsg: String) {

    }
}
