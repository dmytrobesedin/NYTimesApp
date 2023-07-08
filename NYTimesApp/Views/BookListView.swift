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
    }
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.listOfBooks) { result in
                
                VStack(alignment: .center, spacing: 5) {
                    Text(result.title)
                    
                    Text(result.description)
                }
            }
        }
        .onAppear {
            viewModel.getBooks()
        }
        .padding()
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(category: "")
    }
}
