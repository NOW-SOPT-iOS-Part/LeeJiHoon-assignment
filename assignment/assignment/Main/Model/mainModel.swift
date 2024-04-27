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

struct HeadContent {
    let image: UIImage
}

enum SectionType {
    case mainContents(contents: [Content], title: String)
    case freeContents(contents: [FreeContent], title: String)
    case magicContents(contents: [MagicContent], title: String)
    case live(contents: [LiveContent], title: String)
    case headContent(contents: [HeadContent])
}

struct MainModel {
    var sections: [SectionType]

    static func dummy() -> [SectionType] {
        return [
            .headContent(contents: [
                HeadContent(image: UIImage(named: "mainContents")!),
                HeadContent(image: UIImage(named: "mainContents")!),
                HeadContent(image: UIImage(named: "mainContents")!)
            ]),
            .mainContents(contents: [
                Content(image: UIImage(named: "contents1")!, title: "시그널"),
                Content(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                Content(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                Content(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                Content(image: UIImage(named: "contents5")!, title: "두산베어스")
            ], title: "티빙에서 꼭 봐야하는 컨텐츠"),
            .freeContents(contents: [
                FreeContent(image: UIImage(named: "contents1")!, title: "시그널"),
                FreeContent(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                FreeContent(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                FreeContent(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                FreeContent(image: UIImage(named: "contents5")!, title: "두산베어스")
            ], title: "1화무료! 파라마운트 + 인기 시리즈"),
            .magicContents(contents: [
                MagicContent(image: UIImage(named: "contents1")!, title: "시그널"),
                MagicContent(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                MagicContent(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                MagicContent(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                MagicContent(image: UIImage(named: "contents5")!, title: "두산베어스")
            ], title: "마술보다 더 신비로운 영화 (신비로운 영화사전님)"),
            .live(contents: [
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 1"),
                LiveContent(image: UIImage(named: "contents5")!, title: "Live 2")
            ], title: "Live")
        ]
    }
}
