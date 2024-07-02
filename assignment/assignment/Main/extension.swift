//
//  extension.swift
//  assignment
//
//  Created by 이지훈 on 6/4/24.
//

import Foundation

extension Bundle {
    var boxofficeKey: String {
        guard let file = self.path(forResource: "privacyInfo", ofType: "plist") else {
            fatalError("Couldn't find privacyInfo.plist in main bundle.")
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else {
            fatalError("Couldn't load contents of privacyInfo.plist.")
        }
        
        guard let boxofficeKey = resource["BoxOfficeKey"] as? String else {
            fatalError("Couldn't find key 'BoxOfficeKey' in privacyInfo.plist.")
        }
        
        return boxofficeKey
    }
}
