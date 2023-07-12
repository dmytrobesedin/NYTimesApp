//
//  BookAPI.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import Foundation
import RealmSwift

// MARK: - BookAPI
struct BookAPI: Codable {
    let status, copyright: String
    let numResults: Int
    let lastModified: String
    let results: BookAPIResult

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case lastModified = "last_modified"
        case results
    }
}

// MARK: - BookAPIResult
struct BookAPIResult: Codable {
    let listName, bestsellersDate, publishedDate: String
    let displayName: String
    let normalListEndsAt: Int
    let updated: String
    let books: [Book]

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case bestsellersDate = "bestsellers_date"
        case publishedDate = "published_date"
        case displayName = "display_name"
        case normalListEndsAt = "normal_list_ends_at"
        case updated, books
    }
}

// MARK: - Book
class Book: Object, ObjectKeyIdentifiable, Codable, Identifiable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var rank: Int
        //rankLastWeek, weeksOnList, asterisk: Int
    //let dagger: Int
   // let primaryIsbn10, primaryIsbn13,
    @Persisted var publisher: String
        
    
    @Persisted var bookDescription: String
    //let price: String
    @Persisted var title: String
    @Persisted var author: String

        //contributor: String
    //let contributorNote: String
    
    @Persisted var bookImage: String
    @Persisted var bookImageData: Data? = nil
    //let bookImageWidth, bookImageHeight: Int
    //let amazonProductURL: String
   // let ageGroup, bookReviewLink, firstChapterLink, sundayReviewLink: String
   // let articleChapterLink: String
   // let isbns: [Isbn]
  //  let buyLinks: [BuyLink]
    //let bookURI: String

    convenience init(id: UUID = UUID(),
                     rank: Int,
                     publisher: String,
                     description: String,
                     title: String,
                     author: String,
                     bookImage: String) {
        self.init()
        self.id = id
        self.rank = rank
        self.publisher = publisher
        self.bookDescription = description
        self.title = title
        self.author = author
        self.bookImage = bookImage
    }
    
    enum CodingKeys: String, CodingKey {
        case rank
       // case rankLastWeek = "rank_last_week"
       // case weeksOnList = "weeks_on_list"
       // case asterisk, dagger
      //  case primaryIsbn10 = "primary_isbn10"
      //  case primaryIsbn13 = "primary_isbn13"
        case publisher, title, author
        case bookDescription = "description"
       // case contributorNote = "contributor_note"
        case bookImage = "book_image"
//        case bookImageWidth = "book_image_width"
//        case bookImageHeight = "book_image_height"
//        case amazonProductURL = "amazon_product_url"
//        case ageGroup = "age_group"
//        case bookReviewLink = "book_review_link"
//        case firstChapterLink = "first_chapter_link"
//        case sundayReviewLink = "sunday_review_link"
//        case articleChapterLink = "article_chapter_link"
//        case isbns
//        case buyLinks = "buy_links"
//        case bookURI = "book_uri"
    }
}

// MARK: - BuyLink
struct BuyLink: Codable {
    let name: Name
    let url: String
}

enum Name: String, Codable {
    case amazon = "Amazon"
    case appleBooks = "Apple Books"
    case barnesAndNoble = "Barnes and Noble"
    case booksAMillion = "Books-A-Million"
    case bookshop = "Bookshop"
    case indieBound = "IndieBound"
}

// MARK: - Isbn
struct Isbn: Codable {
    let isbn10, isbn13: String
}
