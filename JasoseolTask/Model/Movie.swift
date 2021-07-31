//
//  Movie.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/27.
//

import Foundation

struct Item: Codable {
    var items: [Movie]?
}

struct Movie: Codable {
    var title: String? //제목
    var link: String? //링크
    var image: String? //썸네일
    var director: String? //감독
    var actor: String? //출연
    var userRating: String? //평점
    
    var isLiked: Bool? //즐겨찾기
}
