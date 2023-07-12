//
//  BookListView.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import SwiftUI

struct BookListView: View {
    // MARK: - Properties
    @StateObject var viewModel: BookListViewModel
    
    // MARK: - Init
    init(category: String) {
        let viewModel = BookListViewModel(category: category)
        self._viewModel = StateObject(wrappedValue: viewModel)
        
        Task {
           await viewModel.getBooks()
        }
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .empty:
                EmptyView()
                
            case .loading:
                LoadingView()
                    .navigationBarTitleDisplayMode(.inline)

            case .content:
                ScrollView {
                    ForEach(viewModel.bookModel.books) { book in
                        BookCell(book: book)
                    }
                }
            }
        }
        .onAppear {
//            Task {
//               await viewModel.getBooks()
//            }
        }
        .padding()
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(category: "")
    }
}
