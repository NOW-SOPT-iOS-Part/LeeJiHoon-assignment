//
//  Comfig.swift
//  assignment
//
//  Created by 이지훈 on 5/6/24.
//

import Foundation

enum Config {
    
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    
}


extension Config {
        static let baseURL: String = {
            guard let baseURL = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
                fatalError("Base URL not set in plist for this environment")
            }
            return baseURL
        }()
}
