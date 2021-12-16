//
//  LocalDataManager.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import UIKit
import CoreData

class LocalDataManager {
    
    public static let sharedInstance = LocalDataManager()
    
    private init() {}
    
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
        
    }
   
    
}

extension LocalDataManager {
    
    func getNewsFromCoreData(completion: @escaping ([Dictionary<String,Any>]) -> ()) {
           var allNews : [Dictionary<String,Any>] = []
           
           guard let managedContext = getContext() else { return }
           let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "NewsData")
           let news = try! managedContext.fetch(fetchReq)
        for item in news{
        guard let myData = item.value(forKey: "newsData") else { return}
           guard let obj = NSKeyedUnarchiver.unarchiveObject(with: myData as! Data) as! [Dictionary<String,Any>]? else {return}
           allNews = obj
        }
           print("=====================================\(allNews.count)")
           completion(allNews)
       }
       
       func addNewsToCoreData(news : News,completion: @escaping (Bool) -> ()){
           var articleInfo = Dictionary<String,Any>()
           var allArticles : Array<Dictionary<String,Any>> = []
        
           for item in news.articles{
               articleInfo["auther"] = item.author
               articleInfo["description"] = item.articleDescription
               articleInfo["content"] = item.content
               articleInfo["published"] = item.publishedAt
               articleInfo["title"] = item.title
               articleInfo["url"] = item.url
               articleInfo["urlToImage"] = item.urlToImage
               allArticles.append(articleInfo)
           }
           guard let managedContext = getContext() else { return }
           let entity = NSEntityDescription.entity(forEntityName: "NewsData", in: managedContext)
           let newsData = NSManagedObject(entity: entity!, insertInto: managedContext)
           let date = NSKeyedArchiver.archivedData(withRootObject: allArticles)
           newsData.setValue(date, forKey: "newsData")
           do{
               try managedContext.save()
               completion(true)
           }
           catch let error as NSError{
               print(error)
             completion(false)
           }
       }
}
