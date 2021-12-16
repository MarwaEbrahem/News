//
//  ApplicationNetworking.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import Foundation
import Alamofire

enum ApplicationNetwokring {
    case getNews(country : String, favCategory : String)
}

extension ApplicationNetwokring: TargetType{
    var baseURL: String {
        switch self {
        default:
            return "https://newsapi.org/v2/"
        }
    }
    
    var path: String {
        switch self{
        case .getNews(country : let country, favCategory: let favCategory):
            return "top-headlines?country=\(country)&category=\(favCategory)&apiKey=e311c1b561f242bd91cf586a345a5818"
        
        }
    }
    
    var method: HTTPMethod {
        switch self{
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self{

        case .getNews:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self{
        default:
            return [:]
        }
    }
    
    
}
