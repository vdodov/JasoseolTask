//
//  Network.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/28.
//

import Foundation
import Alamofire

class SearchAPI {
    
    static func getMovieData(_ urlStr: String, completion: @escaping (Swift.Result<Item, Error>) -> Void) {
        guard let urlWithPercentEscapes = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: urlWithPercentEscapes) else { return }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Naver-Client-Id": "TIP8112lgNQKsZGwq_6g",
            "X-Naver-Client-Secret": "PIHZnnh517"
        ]
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
        
        req.validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let movieData = try JSONDecoder().decode(Item.self, from: data)
                        completion(.success(movieData))
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    } 
    
}
