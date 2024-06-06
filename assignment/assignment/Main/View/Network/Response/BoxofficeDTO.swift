//
//  BoxofficeDTO.swift
//  assignment
//
//  Created by 이지훈 on 6/4/24.
//

import Foundation

struct BoxOfficeResponse: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: [Movie]
}

struct Movie: Codable {
    let rnum: String
    let rank: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let salesAmt: String
    let audiCnt: String
}
