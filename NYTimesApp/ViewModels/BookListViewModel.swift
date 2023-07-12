//
//  BookListViewModel.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import Foundation
import SwiftUI

final class BookListViewModel: ObservableObject {
    // MARK: - Properties
    var category: String
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var state: LoadingState = .empty
    
    // MARK: - Private properties
    @ObservedObject private(set) var realmManager = RealmManager.shared
    
    var bookModel: BookModel {
        guard let books = realmManager.user.books.first(where: {$0.categoryId == category}) else {
            return BookModel()
        }
        return books
    }
    // MARK: - Init
    init(category: String) {
        self.category = category
    }
    
    // MARK: - Methods
    func getBooks() async {
        state = .loading
        
        let completionHandler: ((Bool, Error?) -> Void) = { success, error in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if error != nil {
                    self.showAlert(title: "Receive books",
                                   message: error?.localizedDescription ?? "Failed to get books.")
                } else {
                    guard success == true else {
                        self.showAlert(title: "Receive books",
                                       message: "Failed to get books.")
                        return
                    }
                    
                    withAnimation {
                        let hasBooks = self.realmManager.user.books.isEmpty == false
                        self.state = hasBooks ? .content : .empty
                    }
                }
            }
        }
        realmManager.fetchBooksForCategory(category: category, completion: completionHandler)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
