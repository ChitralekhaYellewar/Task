//
//  TagsListInteractor.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import Foundation
import ObjectMapper

class TagsListInteractor {
    let service = TagsListService()
    
    weak var presenter: TagsListPresenterInterface?
    
    let coreDataManager = CoreDataManager()

}

extension TagsListInteractor: TagsListInteractorInterface {
    
    
    func fetchMappingSets(for selectedIndex: IndexPath) {
        guard let mappingSets = coreDataManager.getMappingSetsData() else { return }
        
        if mappingSets.count == 0 {
            service.fetchMappableSets(completion: { [weak self] sets in
                guard let mappingSets = sets else { return }
                
                #if DEBUG
                print(mappingSets)
                #endif
                
                self?.coreDataManager.deleteAllData(for: coreDataConstants.MappingSetsData)
                self?.coreDataManager.saveMappingSets(data: mappingSets)
                
                // get mapping sets from core data.
                guard let savedMappingSets = self?.coreDataManager.getMappingSetsData() else { return }
                self?.presenter?.mappingSetsFetched(list: savedMappingSets)
                
                self?.fetchTagsList(for: 0, for: selectedIndex)
                
                }, failure: { [weak self] (errorMsg) in
                    guard let error = errorMsg else { return }
                    self?.presenter?.tagsListFetchedFailed(with: error.localizedDescription)
                    
            })
        } else {
            self.presenter?.mappingSetsFetched(list: mappingSets)
            self.fetchTagsList(for: 0, for: selectedIndex)
        }
    }
    

    func fetchTagsList(for segmentIndex: Int,for selectedArticleIndex: IndexPath) {
        
        guard let mappingSets = coreDataManager.getMappingSetsData(), let tagsList = coreDataManager.getTagsData(with: mappingSets[segmentIndex].id) else { return }
        
        if tagsList.count == 0 {
            let selectedMappingSet = mappingSets[segmentIndex].id
            
            service.fetchTagsMapping(for: selectedMappingSet, with: { [weak self] (tags) in
                guard let tagsList = tags else { return }
                
                self?.coreDataManager.saveTags(data: tagsList, for: selectedMappingSet)
                
                self?.sortTags(for: selectedArticleIndex, segmentIndex: segmentIndex)
                
                }, failure: { [weak self] (errorMsg) in
                    guard let error = errorMsg else { return }
                    self?.presenter?.tagsListFetchedFailed(with: error.localizedDescription)
                    
            })
        } else {
            self.sortTags(for: selectedArticleIndex, segmentIndex: segmentIndex)
        }
    }
    
    func sortTags(for articleIndex:IndexPath, segmentIndex: Int) {
        
        guard let selectedArticle = coreDataManager.getArticlesData(), let mappingSet = coreDataManager.getMappingSetsData() else { return }
        
        let selectedMappingSet = mappingSet[segmentIndex].id
        
        guard let tagsForMappingSet = coreDataManager.getTagsData(with: selectedMappingSet) else { return }
        
        let tagsOfArticle = selectedArticle[articleIndex.row].articlesTags
        
        var sourceTagsToShow = [String : Int]()
        
        var tagsToShowList = [String]()
        
        var tagFound: Tags?
        
        for sourceTag in tagsOfArticle {
            var priority = 0
            
            for tag in tagsForMappingSet {
                if tag.sourceTags.contains(sourceTag) {
                    #if DEBUG
                    print(sourceTag)
                    #endif
                    priority += 1
                    tagFound = tag
                    
                    print("SorceTag and Priority: \(sourceTag) \(priority)")
                }
                
            }
            if let tagToShow = tagFound {
                sourceTagsToShow[tagToShow.destinationValue] = priority
            }
        }
        
        print(sourceTagsToShow)
        
        let sortedTagslist = sourceTagsToShow.sorted(by: {$0.1 > $1.1} )
        
        sortedTagslist.forEach { (tagName, priority) in
            tagsToShowList.append(tagName)
        }
    
        self.presenter?.tagsListFetched(TagsList: tagsToShowList, selectedIndex: articleIndex)
    
    }
    
    
    func segmentSelected(for index: IndexPath, segmentIndex: Int) {
        
        guard let selectedArticle = coreDataManager.getArticlesData(),
            let selectedMappingSet = coreDataManager.getMappingSetsData(),
            let tagsForMappingSet = coreDataManager.getTagsData(with: selectedMappingSet[segmentIndex].id) else { return }
        
        if selectedMappingSet.count == 0 {
            fetchMappingSets(for: index)
        } else if tagsForMappingSet.count == 0 {
            fetchTagsList(for: segmentIndex, for: index)
        }
        
        let tagsOfArticle = selectedArticle[index.row].articlesTags
        
        var sourceTagsToShow = [String : Int]()
        
        var tagsToShowList = [String]()
        
        var tagFound: Tags?
        
        var priority = 0
        
        ////
        
        var destinationsFound = [String: [String]]()
        var desArray = [String]()
        ////
        
        for sourceTag in tagsOfArticle {
            
            for tag in tagsForMappingSet {
                if tag.sourceTags.contains(sourceTag) {
                    #if DEBUG
                    print(sourceTag)
                    #endif
                    priority += 1
                    
                    desArray.append(tag.destinationValue)
                    
                    tagFound = tag
                    
                    print("SorceTag and Priority: \(sourceTag) \(priority)")
                }
                
            }
            
            destinationsFound[sourceTag] = desArray
            
            desArray = [String]()
            
        }
        
        let allDestinationValues = destinationsFound.values.flatMap( { $0 } )
        
        print("allDestinationValues::: \(allDestinationValues)")
        var priorities = 0
        
        var desValue = String()
        
        destinationsFound.forEach { (sourceTag, destinations) in
            
            destinations.forEach({ desElement in
                let maxPriority = allDestinationValues.filter( { $0 == desElement }).count
                if maxPriority > priorities {
                    priorities = maxPriority
                    desValue = desElement
                }
            })
            
            sourceTagsToShow[desValue] = priorities
            priorities = 0
        }
        
        print(sourceTagsToShow)
        
        let sortedTagslist = sourceTagsToShow.sorted(by: {$0.1 > $1.1} )
        
        sortedTagslist.forEach { (tagName, priority) in
            tagsToShowList.append(tagName)
        }

        self.presenter?.tagsListFetched(TagsList: tagsToShowList, selectedIndex: index)
    }
    
}


