//
//  MovieModelManager.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/28.
//

import Foundation

class MovieModelManager {
    static let shared = MovieModelManager()
    
    private init() {}

    //검색어(키워드)
    var key: String = ""
    
    //검색결과 배열
    var movieDataArr: [String: Item] =  Dictionary()
    
    //즐겨찾기 배열
    var likeMoiveDataArr: [Movie] = Array()
}
