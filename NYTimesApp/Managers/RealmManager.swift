//
//  RealmManager.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 10.07.2023.
//

import SwiftUI
import RealmSwift

final class RealmManager: ObservableObject {
    // MARK: - Constants
    static let shared = RealmManager()
    
    // MARK: - Private properties
    @Published private(set) var user: User
    private lazy var bookAPIService = BookAPIService.shared
    
    // MARK: - Init
    private init() {
       self.user = User()
    }
    
    // MARK: - Methods
    private func realm() throws -> Realm {
        let config = Realm.Configuration(schemaVersion: 2)
        
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    
        return try Realm()
    }
    
    func fetchCategories(completion: ((Bool, Error?) -> Void)? = nil) {
        bookAPIService.fetchCategories { result in
            DispatchQueue.main.async { [weak self] in
                
                guard let self else { return }
                switch result {
                case .success(let categoryAPI):
                    guard let realm = try? self.realm() else { return }
                    if let categoryAPI = categoryAPI {
                        do {
                            try realm.write {
                                realm.delete(realm.objects(CategoryAPIResult.self))
                                realm.add(categoryAPI, update: .modified)
                            }
                            self.setCategories(categoryAPI, completion: completion)
                        } catch {
                            self.setCategories(nil, completion: completion)
                        }
                    } else {
                        self.retrieveCategoriesFromRealm(completion: completion)
                    }
            
                case .failure(let failure):
                    self.retrieveCategoriesFromRealm(completion: completion)
                    completion?(false, failure)
                }
            }
        }
    }
    
    func fetchBooksForCategory(category: String, completion: ((Bool, Error?) -> Void)? = nil) {
        bookAPIService.fetchBooksForCategory(category: category) { result in
            DispatchQueue.main.async { [weak self] in
                
                guard let self else { return }
                switch result {
                case .success(let books):
                    guard let realm = try? self.realm() else { return }
                    if let books = books {
                        let bookModel = BookModel(category: category, books: books)
                        do {
                            try realm.write {
                                if let bookModel = realm.objects(BookModel.self).first(where: {$0.categoryId == category}) {
                                    realm.delete(bookModel)
                                }
                                
                                realm.add(bookModel, update: .modified)
                            }
                            self.setBooks(bookModel, completion: completion)
                        } catch {
                            self.setBooks(nil, completion: completion)
                        }
                    } else {
                        self.retrieveBooksFromRealm(category: category, completion: completion)
                    }
            
                case .failure(let failure):
                    self.retrieveBooksFromRealm(category: category, completion: completion)
                    completion?(false, failure)
                }
            }
        }
    }
    
    private func setBooks(_ userBooks: BookModel? = nil, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            withAnimation { [weak self] in
                guard let self else { return }
                self.updateRealmCollection {
                    if let userBooks {
                        if let newBook = self.user.books.first(where: {$0.categoryId != userBooks.categoryId}) {
                            self.user.books.append(newBook)
                        }
                    } else {
                        self.user.books.removeAll()
                    }
                }
            }
            completion?(true, nil)
        }
    }
    
    private func setCategories(_ userCategories: [CategoryAPIResult]? = nil, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            withAnimation { [weak self] in
                guard let self else { return }
                self.updateRealmCollection {
                    if let userCategories {
                        self.user.categories.append(objectsIn: userCategories)
                    
                    } else {
                        self.user.categories.removeAll()
                    }
                }
            }
            completion?(true, nil)
        }
    }

    func setUserCategories(_ categories: [CategoryAPIResult]? = nil, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
             [weak self] in
                guard let self else { return }
                self.updateRealmCollection {
                    if let categories {
                        self.user.categories.removeAll()
                        self.user.categories.append(objectsIn: categories)
                    } else {
                        self.user.categories.removeAll()
                    }
                }
                
                completion?(true, nil)
            
        }
    }
    
    func updateRealmCollection(completion: (() -> ())? = nil) {
        guard let realm = try? self.realm() else { return }
        
        do {
            try realm.write {
                completion?()
                realm.add(self.user, update: .modified)
            }
        } catch {
            completion?()
        }
    }
    
    func retrieveCategoriesFromRealm(completion: ((Bool, Error?) -> Void)? = nil) {
        guard let realm = try? self.realm() else { return }
        let realmCategories = realm.objects(CategoryAPIResult.self)
   
        DispatchQueue.main.async {
            withAnimation { [weak self] in
                guard let self else { return }
                self.updateRealmCollection {
                    if !realmCategories.isEmpty {
                        self.user.categories.removeAll()
                        self.user.categories.append(objectsIn: Array(realmCategories))
                        completion?(true, nil)
                    }
                }
            }
        }
    }
    
    func retrieveBooksFromRealm(category: String, completion: ((Bool, Error?) -> Void)? = nil) {
        guard let realm = try? self.realm() else { return }
        let realmBooks = realm.objects(BookModel.self).first(where: { $0.categoryId == category })

        DispatchQueue.main.async {
            withAnimation { [weak self] in
                guard let self else { return }
                self.updateRealmCollection {
                    if let realmBooks = realmBooks {
                        self.user.books.removeAll()
                        self.user.books.append(realmBooks)
                        completion?(true, nil)
                    }
                }
            }
        }
    }
}
