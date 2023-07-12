//
//  CategoryAPI.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import Foundation
import RealmSwift

// MARK: - CategoryAPI
class CategoryAPI: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [CategoryAPIResult]
    
    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - CategoryAPIResult
class CategoryAPIResult: Object, ObjectKeyIdentifiable, Codable, Identifiable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var listName: String
    @Persisted var displayName: String
    @Persisted var listNameEncoded: String
    @Persisted var oldestPublishedDate: String
    @Persisted var newestPublishedDate: String

    convenience init(id: UUID = UUID(),
                     listName: String,
                     displayName: String,
                     listNameEncoded: String,
                     oldestPublishedDate: String,
                     newestPublishedDate: String) {
        self.init()
        self.id = id
        self.listName = listName
        self.displayName = displayName
        self.listNameEncoded = listNameEncoded
        self.oldestPublishedDate = oldestPublishedDate
        self.newestPublishedDate = newestPublishedDate
    }
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
        case oldestPublishedDate = "oldest_published_date"
        case newestPublishedDate = "newest_published_date"
    }
}
