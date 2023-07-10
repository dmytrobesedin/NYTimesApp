//
//  BookCell.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 10.07.2023.
//

import SwiftUI

struct BookCell: View {
    // MARK: - Constants
    let progressSize: CGFloat = 44
    let imageWidth: CGFloat = 70
    let imageHeight: CGFloat = 100
    
    // MARK: - Properties
    @State var isLoading = false
    @State var bookImage = Image(systemName: Constants.questionMarkSquare)
    var book: Book
    
    // MARK: - Private properties
    @ObservedObject private var bookAPIService = BookAPIService.shared
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            if isLoading {
                ProgressView()
                    .frame(width: progressSize,
                           height: progressSize,
                           alignment: .center)
                    .padding()
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white,
                                          lineWidth: 4)
                    )
            } else {
                bookImage
                    .resizable()
                    .frame(width: imageWidth,
                           height: imageHeight,
                           alignment: .center)
            }
            
            bookInfoView
            
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width - 24)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.25)))
        .onAppear {
            fetchBookImage()
        }
    }
    
    private var bookInfoView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(book.title)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(Book.CodingKeys.author.rawValue) - \(book.author)")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black)
                
                Text("\(Book.CodingKeys.publisher.rawValue) - \(book.publisher)")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black)
                
                Text("\(Book.CodingKeys.rank.rawValue) - \(book.rank)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black)
            }
            
            Text("\(Book.CodingKeys.description.rawValue) - \(book.description)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
        }
    }
    
    private func fetchBookImage() {
        isLoading = true
        bookAPIService.fetchBookImage(bookURL: book.bookImage) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    bookImage = success
                    isLoading = false
                }
            case .failure(let failure):
                isLoading = false
                print("error \(failure.localizedDescription)")
            }
        }
    }
}

