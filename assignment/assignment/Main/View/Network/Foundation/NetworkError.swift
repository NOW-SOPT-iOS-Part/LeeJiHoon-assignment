//
//  NetworkError.swift
//  assignment
//
//  Created by 이지훈 on 6/4/24.
//

import Foundation

import Moya

enum MovieError: Error {
    case networkError(MoyaError)
    case decodingError
    case unknownError
}

extension MovieError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError:
            return "Failed to decode the response."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
