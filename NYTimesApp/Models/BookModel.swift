//
//  BookModel.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 12.07.2023.
//

import Foundation
import RealmSwift

class BookModel: Object {
    @Persisted(primaryKey: true) var categoryId: String
    @Persisted var books: List<Book> = List<Book>()
    
    convenience init(category: String = "", books: [Book] = [Book]()) {
        self.init()
        self.categoryId = category
        self.books.append(objectsIn: books)
    }
}
