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
    let subTitle: String
    let liter: String
    let award: Int
}

struct HeadContent {
    let image: UIImage
}

struct DoosanContent {
    let image: UIImage
}

enum SectionType {
    case mainContents(contents: [Content], title: String)
    case freeContents(contents: [FreeContent], title: String)
    case magicContents(contents: [MagicContent], title: String)
    case live(contents: [LiveContent], title: String)
    case headContent(contents: [HeadContent])
    case DoosanContent(contents: [DoosanContent])
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
            .live(contents: [
            LiveContent(image: UIImage(named: "live1")!, title: "Mnet", subTitle: "보이즈플래닛 12화", liter: "80.1%", award: 1),
            LiveContent(image: UIImage(named: "live2")!, title: "Mnet", subTitle: "하트시그넝 4화", liter: "22%2", award: 2),
            LiveContent(image: UIImage(named: "live1")!, title: "Mnet", subTitle: "하트시그넝 4화", liter: "22%2", award: 3),
            LiveContent(image: UIImage(named: "live2")!, title: "Mnet", subTitle: "하트시그넝 4화", liter: "22%2", award: 4)
        ], title: "인기 Live 채널"),
            .freeContents(contents: [
                FreeContent(image: UIImage(named: "contents1")!, title: "시그널"),
                FreeContent(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                FreeContent(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                FreeContent(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                FreeContent(image: UIImage(named: "contents5")!, title: "두산베어스")
            ], title: "1화무료! 파라마운트 + 인기 시리즈"),
            
            .DoosanContent(contents: [
                DoosanContent(image: UIImage(named: "blackDoosan")!),
                DoosanContent(image: UIImage(named: "whiteDoosan")!),
                DoosanContent(image: UIImage(named: "blackDoosan")!),
                DoosanContent(image: UIImage(named: "whiteDoosan")!)
            ]),
            .magicContents(contents: [
                MagicContent(image: UIImage(named: "contents1")!, title: "시그널"),
                MagicContent(image: UIImage(named: "contents2")!, title: "해리포터와 마법사의돌"),
                MagicContent(image: UIImage(named: "contents3")!, title: "반지의 제왕"),
                MagicContent(image: UIImage(named: "contents4")!, title: "스즈메의 문단속"),
                MagicContent(image: UIImage(named: "contents5")!, title: "두산베어스")
            ], title: "마술보다 더 신비로운 영화 (신비로운 영화사전님)")
          
        ]
    }
}
