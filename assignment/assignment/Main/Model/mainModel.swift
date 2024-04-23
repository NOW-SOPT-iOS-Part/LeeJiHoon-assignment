//
//  mainModel.swift
//  assignment
//
//  Created by 이지훈 on 4/22/24.
//

import Foundation
import UIKit

struct Content {
    let image: UIImage
    let title: String
}

struct LiveContent {
    let image: UIImage
    let title: String
}

enum SectionType {
    case mainContents([Content])
    case live([LiveContent])
}

struct MainModel {
    var sections: [SectionType]

    static func dummy() -> [SectionType] {
        return [
            .mainContents([
                Content(image: UIImage(named: "contents1")!, title: "Title 1"),
                Content(image: UIImage(named: "contents2")!, title: "Title 1"),
                Content(image: UIImage(named: "contents3")!, title: "Title 1"),
                Content(image: UIImage(named: "contents4")!, title: "Title 1"),
                Content(image: UIImage(named: "contents5")!, title: "Title 1")
            ]),
            .live([
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 2")
            ])
        ]
    }
}

