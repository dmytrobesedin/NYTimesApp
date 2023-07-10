//
//  BookAPIError.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 10.07.2023.
//

import Foundation

enum BookAPIError: Error {
    case invalidURL(description: String = "Invalid URL.")
    case invalidImage(description: String = "Invalid Image.")
    case invalidResponseData(description: String = "Invalid response data.")
}
