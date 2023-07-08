//
//  BookAPIService.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 08.07.2023.
//

import Foundation
import SwiftUI


final class BookAPIService: ObservableObject {
    // MARK: - Constants
    static let shared = BookAPIService()
    
    // MARK: - Private properties
    private let session = URLSession.shared
    private let apiKey = "pcNHSTb3ZwSuXvG0hXyBhNX9rkBUqwnd"
    private let baseUrlString = "https://api.nytimes.com/svc/books/v3/lists/"
    
    // MARK: - Methods
    func fetchBookCategories(completion: @escaping (Result<CategoryAPI, Error>) -> Void)  {
        let urlString = baseUrlString + "names?api-key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = session.dataTask(with: url) { (data, urlResponse, anotherError) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let decodeData = try jsonDecoder.decode(CategoryAPI.self, from: data)
                completion(.success(decodeData))
            }
            catch (let error){
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func fetchBooksForCategory(category: String, completion: @escaping (Result<BookAPI, Error>) -> Void) {
        let urlString = baseUrlString + "\(category)?api-key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = session.dataTask(with: url) { (data, urlResponse, anotherError) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let decodeData = try jsonDecoder.decode(BookAPI.self, from: data)
                completion(.success(decodeData))
            }
            catch (let error){
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}

