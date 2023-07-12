//
//  CategoriesListView.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import SwiftUI

struct CategoriesListView: View {
    // MARK: - Properties
    @StateObject var viewModel = CategoriesListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .loading:
                    LoadingView()
                        .navigationBarTitleDisplayMode(.inline)
                case .empty:
                    EmptyView()
                case .content:
                    categories
                }
            }
            .onAppear {
                Task {
                    await viewModel.getCategories()
                }
            }
//            .navigationDestination(for: String.self) { value in
//                BookListView(category: value)
//            }
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            })
        }
     
    }
    
    var categories: some View {
        ScrollView {
            ForEach(viewModel.realmManager.user.categories) { result in
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(result.listName)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text(result.newestPublishedDate)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: BookListView(category: result.listNameEncoded), label: {
                            Image(systemName: "arrow.right")
                                .buttonStyle(.borderless)
                        })
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.25)))
                }
        }
        .padding(.horizontal, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView()
    }
}
