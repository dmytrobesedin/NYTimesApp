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
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var state: LoadingState = .empty

    // MARK: - Private properties
    @ObservedObject private(set) var realmManager = RealmManager.shared
    
    // MARK: - Methods
    func getCategories() async {
        state = .loading
        let completionHandler: ((Bool, Error?) -> Void) = { success, error in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if error != nil {
                    self.showAlert(title: "Receive categories",
                                   message: error?.localizedDescription ?? "Failed to get Categories.")
                } else {
                    guard success == true else {
                        self.showAlert(title: "Receive categories",
                                       message: "Failed to get categories.")
                        return
                    }
                    
                    withAnimation {
                        let hasCategories = self.realmManager.user.categories.isEmpty == false
                        self.state = hasCategories ? .content : .empty
                    }
                }
            }
        }
        realmManager.fetchCategories(completion: completionHandler)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
