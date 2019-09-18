//
//  DataManager.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit
import CoreData

struct ArticleData {
    var Articles : [NSManagedObject] {
        didSet {
            #if DEBUG
            print(Articles)
            #endif
        }
    }
}

struct MappingSetData {
    var MappingSets : [NSManagedObject] {
        didSet {
            #if DEBUG
            print(MappingSets)
            #endif
        }
    }
}

struct TagsData {
    var Tags : [NSManagedObject] {
        didSet {
            #if DEBUG
            print("Tags from core data :\(Tags)")
            #endif
        }
    }
}

class CoreDataManager: NSManagedObject {
    
    var appDelegate : AppDelegate?
    var context : NSManagedObjectContext?
    
    var articlesCoreData = ArticleData(Articles: [])
    var articlesEntity: NSEntityDescription?
    
    var mappingSetCoreData = MappingSetData(MappingSets: [])
    var mappingSetEntity: NSEntityDescription?
    
    var tagsCoreData = TagsData(Tags: [])
    var tagsEntity: NSEntityDescription?

    
    //MARK: - initial set up for core data.
    func initCoreData() {
        
        // Initialise appdelegate before any operations to access core data database.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        context = appDelegate.persistentContainer.viewContext
        
        articlesEntity = NSEntityDescription.entity(forEntityName: coreDataConstants.ArticlesData, in: context!)!
        mappingSetEntity = NSEntityDescription.entity(forEntityName: coreDataConstants.MappingSetsData, in: context!)!
        tagsEntity = NSEntityDescription.entity(forEntityName: coreDataConstants.TagData, in: context!)!
        
    }
    
    //MARK: - save articles to core data.
    func saveArticles(data: [Articles]) {
        initCoreData()
        deleteAllData(for: coreDataConstants.ArticlesData)
        for article in data {
            let articleToSave = NSManagedObject(entity: articlesEntity!, insertInto: context)
            insert(articleData: article, in: articleToSave)
        }
        saveData()
    }

    //MARK: - insert article data to NSManagedObject.
    private func insert(articleData: Articles, in articles: NSManagedObject) {
        articles.setValue(articleData.articlesID, forKey: coreDataConstants.UUID)
        articles.setValue(articleData.articlesName, forKey: coreDataConstants.Name)
        articles.setValue(articleData.articlesSortOrder, forKey: coreDataConstants.SortingOrder)
        articles.setValue(articleData.articlesTags, forKey: coreDataConstants.Tags)
    }
    
    //MARK: - save core data changes.
    func saveData() {
        do {
            try context!.save()
        } catch let error as NSError {
            NSLog("error while saving to core data ", error.userInfo)
        }
    }
    
    //MARK: - fetch articles core data.
    private func fetchArticlesData() {
        
        initCoreData()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: coreDataConstants.ArticlesData)
        let sortOrder = NSSortDescriptor(key: coreDataConstants.SortingOrder, ascending: true)
        fetchRequest.sortDescriptors = [sortOrder]
        
        do {
            articlesCoreData.Articles = try context!.fetch(fetchRequest)
            print(articlesCoreData.Articles.count)
        } catch let error as NSError {
            NSLog("Could not fetch data ", error.localizedDescription)
        }
    }
    
    //MARK: - get articles array from core data.
    func getArticlesData() -> [Articles]? {
        fetchArticlesData()
        return Articles.getArticlesFrom(data: articlesCoreData.Articles)
    }
    
    //MARK: - clear all articles data from core data.
    func deleteAllData(for entityName: String) {
        initCoreData()
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context!.execute(deleteRequest)
            try context!.save()
        } catch {
            print ("There was an error")
        }
    }
}

extension CoreDataManager {
    //MARK: - save mapping sets to core data.
    func saveMappingSets(data: [MappingSets]) {
        initCoreData()
        deleteAllData(for: coreDataConstants.MappingSetsData)
        for mappingSet in data {
            let mappingSetToSave = NSManagedObject(entity: mappingSetEntity!, insertInto: context)
            insert(mappingSetData: mappingSet, in: mappingSetToSave)
        }
        saveData()
    }
    
    //MARK: - insert mapping set data to NSManagedObject.
    private func insert(mappingSetData: MappingSets, in mappingSets: NSManagedObject) {
        mappingSets.setValue(mappingSetData.id, forKey: coreDataConstants.UUID)
        mappingSets.setValue(mappingSetData.name, forKey: coreDataConstants.Name)
    }
    
    //MARK: - fetch mapping sets core data.
    private func fetchMappingSetData() {
        
        initCoreData()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: coreDataConstants.MappingSetsData)
        let sortOrder = NSSortDescriptor(key: coreDataConstants.Name, ascending: true)
        fetchRequest.sortDescriptors = [sortOrder]
        
        do {
            mappingSetCoreData.MappingSets = try context!.fetch(fetchRequest)
            print(mappingSetCoreData.MappingSets.count)
        } catch let error as NSError {
            NSLog("Could not fetch data ", error.localizedDescription)
        }
    }
    
    //MARK: - get mapping array from core data.
    func getMappingSetsData() -> [MappingSets]? {
        fetchMappingSetData()
        return MappingSets.getMappingSetsFrom(data: mappingSetCoreData.MappingSets)
    }
}

extension CoreDataManager {
    //MARK: - save tags to core data.
    func saveTags(data: [Tags], for mappingSet: String) {
        initCoreData()
        //deleteAllData(for: "TagData")
        for tags in data {
            let tagsToSave = NSManagedObject(entity: tagsEntity!, insertInto: context)
            insert(tagsData: tags, in: tagsToSave, for: mappingSet)
        }
        saveData()
    }
    
    //MARK: - insert tags data to NSManagedObject.
    private func insert(tagsData: Tags, in tags: NSManagedObject, for set: String) {
        tags.setValue(tagsData.tagsId, forKey: coreDataConstants.UUID)
        tags.setValue(tagsData.sortOrder, forKey: coreDataConstants.SortingOrder)
        tags.setValue(tagsData.sourceTags, forKey: coreDataConstants.SourceTags)
        tags.setValue(tagsData.destinationValue, forKey: coreDataConstants.DestinationValue)
        tags.setValue(set, forKey: coreDataConstants.MappingSet)
    }
    
    //MARK: - fetch tags core data.
    private func fetchTagsData() {
        
        initCoreData()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: coreDataConstants.TagData)
        
        do {
            tagsCoreData.Tags = try context!.fetch(fetchRequest)
            print(tagsCoreData.Tags.count)
        } catch let error as NSError {
            NSLog("Could not fetch data ", error.localizedDescription)
        }
    }
    
    //MARK:- private method to fetch tags from core data.
    private func fetchTagsData(for id: String) {
        
        initCoreData()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: coreDataConstants.TagData)
        
        let predicate = NSPredicate(format: "mapping_set == %@", id)
        
        fetchRequest.predicate = predicate
        
        do {
            tagsCoreData.Tags = try context!.fetch(fetchRequest)
            print(tagsCoreData.Tags.count)
        } catch let error as NSError {
            NSLog("Could not fetch data ", error.localizedDescription)
        }
    }
    
    //MARK: - get tags array from core data.
    func getTagsData(with id: String) -> [Tags]? {
        fetchTagsData(for: id)
        return Tags.getTagsFrom(data: tagsCoreData.Tags)
    }
    
    //MARK: - get tags array from core data.
    func getTagsData() -> [Tags]? {
        fetchTagsData()
        return Tags.getTagsFrom(data: tagsCoreData.Tags)
    }
}
