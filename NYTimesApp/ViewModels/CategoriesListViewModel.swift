//
//  CategoriesListViewModel.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import Foundation
import SwiftUI

final class CategoriesListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var categories = [CategoryAPIResult]()
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    // MARK: - Private properties
    @ObservedObject private var bookAPIService = BookAPIService.shared
    
    // MARK: - Methods
    func getCategories() {
        bookAPIService.fetchBookCategories {  result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in 
                    guard let self else { return }
                    self.categories = success.results
                }
            case .failure(let failure):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.alertTitle = "Receive Categories"
                    self.alertMessage = failure.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}
