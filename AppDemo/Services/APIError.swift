//
//  APIError.swift
//  AppDemo
//
//  Created by Daniel Bonates on 09/12/21.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case invalidResponseFormat
    case unknown

    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "invalid URL"
        case .noData:
            return "no data to decode"
        case .invalidResponseFormat:
            return "response format unexpected"
        case .unknown:
            return "network error, not known"
        }
    }
}
