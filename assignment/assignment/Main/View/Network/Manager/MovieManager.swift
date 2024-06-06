//
//  MovieManager.swift
//  assignment
//
//  Created by 이지훈 on 6/4/24.
//

import Foundation

import Moya

class MovieManager {
    private let provider = MoyaProvider<MovieAPI>()
    
    func fetchDailyBoxOffice(key: String, targetDate: String, completion: @escaping (Result<[Movie], MovieError>) -> Void) {
        provider.request(.dailyBoxOffice(key: key, targetDate: targetDate)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let dailyBoxOfficeResponse = try decoder.decode(BoxOfficeResponse.self, from: response.data)
                    completion(.success(dailyBoxOfficeResponse.boxOfficeResult.dailyBoxOfficeList))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}
