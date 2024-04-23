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

struct FreeContent {
    let image: UIImage
    let title: String
}

struct MagicContent {
    let image: UIImage
    let title: String
}

struct LiveContent {
    let image: UIImage
    let title: String
}

enum SectionType {
    case mainContents(contents: [Content], title: String)
    case freeContents(contents: [FreeContent], title: String)
    case magicContents(contents: [MagicContent], title: String)
    case live(contents: [LiveContent], title: String)
}


struct MainModel {
    var sections: [SectionType]

    static func dummy() -> [SectionType] {
        return [
            .mainContents(contents: [
                Content(image: UIImage(named: "contents1")!, title: "시그널"),
                Content(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                Content(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                Content(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                Content(image: UIImage(named: "contents5")!, title: "두산베어스")
                
            ], title: "Main Contents"),
            .freeContents(contents: [
                FreeContent(image: UIImage(named: "contents1")!, title: "시그널"),
                FreeContent(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                FreeContent(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                FreeContent(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                FreeContent(image: UIImage(named: "contents5")!, title: "두산베어스")
            ], title: "Free Contents"),
            .magicContents(contents: [
                MagicContent(image: UIImage(named: "contents1")!, title: "시그널"),
                MagicContent(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                MagicContent(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                MagicContent(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                MagicContent(image: UIImage(named: "contents5")!, title: "두산베어스")
            ], title: "Magic Contents"),
            .live(contents: [
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 2")
            ], title: "Live")
        ]
    }
}

