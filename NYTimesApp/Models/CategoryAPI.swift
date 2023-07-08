//
//  CategoryAPI.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import Foundation

// MARK: - CategoryAPI
struct CategoryAPI: Codable {
    let status, copyright: String
    let numResults: Int
    let results: [CategoryAPIResult]

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - CategoryAPIResult
struct CategoryAPIResult: Codable, Identifiable {
    let id = UUID()
    let listName, displayName, listNameEncoded, oldestPublishedDate: String
    let newestPublishedDate: String
    let updated: Updated

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
        case oldestPublishedDate = "oldest_published_date"
        case newestPublishedDate = "newest_published_date"
        case updated
    }
}

enum Updated: String, Codable {
    case monthly = "MONTHLY"
    case weekly = "WEEKLY"
}
