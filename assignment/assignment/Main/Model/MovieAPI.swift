//
//  MovieAPI.swift
//  assignment
//
//  Created by 이지훈 on 5/6/24.
//

import Foundation
import Moya

enum MovieAPI {
    case dailyBoxOffice(key: String, targetDate: String)
}

extension MovieAPI: TargetType {
    var baseURL: URL { return URL(string: Config.baseURL)! }
    
    var path: String {
        switch self {
        case .dailyBoxOffice:
            return "/searchDailyBoxOfficeList.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case let .dailyBoxOffice(key, targetDate):
            return .requestParameters(parameters: ["key": key, "targetDt": targetDate], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
