//
//  NewsAPI.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import Foundation
protocol NewsAPIProtocol{
    
    func getNews(country : String, favCategory : String, completion: @escaping (Result<News?,NSError>) -> ())
}

class NewsAPI: BaseAPI<ApplicationNetwokring>,NewsAPIProtocol{
    
    static let shared = NewsAPI()
    private override init() {}
    
    
    func getNews(country: String, favCategory: String, completion: @escaping (Result<News?, NSError>) -> ()) {
        self.fetchData(target: .getNews(country: country, favCategory: favCategory), responseClass: News.self) { (result) in
            completion(result)
        }
    }

}
