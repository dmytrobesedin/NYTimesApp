//
//  User.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 11.07.2023.
//

import Foundation
import RealmSwift

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var uid: String = "userID"
    
    @Persisted var categories: List<CategoryAPIResult> = List<CategoryAPIResult>()
    // @Persisted var books: Books = Books()
    @Persisted var books: List<BookModel> = List<BookModel>()
    
}
