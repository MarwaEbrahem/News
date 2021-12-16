//
//  News.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import Foundation

// MARK: - News
struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        articleDescription = try values.decodeIfPresent(String.self, forKey: .articleDescription)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        
    }
}

//// MARK: - Source
//struct Source: Codable {
//    let id: String?
//    let name: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "name"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey:.id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//    }
//}

