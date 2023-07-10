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
    private let apiKey = "?api-key=pcNHSTb3ZwSuXvG0hXyBhNX9rkBUqwnd"
    
    // MARK: - Methods
    func fetchBookCategories(completion: @escaping (Result<CategoryAPI, Error>) -> Void)  {
        let urlString = RequestPathConstants.baseURLString + RequestPathConstants.getCategories + apiKey
        guard let url = URL(string: urlString) else {
            completion(.failure(BookAPIError.invalidURL()))
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
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
        let urlString = RequestPathConstants.baseURLString + "\(category)" + apiKey
        guard let url = URL(string: urlString) else {
            completion(.failure(BookAPIError.invalidURL()))
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(BookAPIError.invalidResponseData()))
                }
                return
            }
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
    
    func fetchBookImage(bookURL: String, completion: @escaping (Result<Image, Error>) -> Void) {
        guard let url = URL(string: bookURL) else {
            completion(.failure(BookAPIError.invalidURL()))
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data else {
                completion(.failure(BookAPIError.invalidResponseData()))
                return
            }
            guard let uiImage = UIImage(data: data) else {
                completion(.failure(BookAPIError.invalidImage()))
                return
            }
            completion(.success(Image(uiImage: uiImage)))
        }
        dataTask.resume()
    }
}

