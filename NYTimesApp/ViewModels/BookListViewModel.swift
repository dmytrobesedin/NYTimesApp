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
    @Published var listOfBooks = [Book]()
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    // MARK: - Private properties
    @ObservedObject private var bookAPIService = BookAPIService.shared
    
    // MARK: - Init
    init(category: String) {
        self.category = category
    }
    
    // MARK: - Methods
    func getBooks() {
        bookAPIService.fetchBooksForCategory(category: category) { result in
            switch result {
            case .success(let bookAPI):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.listOfBooks = bookAPI.results.books
                }
            case .failure(let failure):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.alertTitle = "Receive Books"
                    self.alertMessage = failure.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}
