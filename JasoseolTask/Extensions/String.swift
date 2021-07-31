//
//  String.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/29.
//

import Foundation

extension String {
    func checkString(_ str: String?) -> String {
        guard let str = str else { return "No Data" }
        
        if str == "" {
            return "No Data"
        } else {
            let strResult = str.replacingOccurrences(of: "<b>", with: "")
                .replacingOccurrences(of: "</b>", with: "")
                .replacingOccurrences(of: "|", with: ", ")
            
            return strResult
        }
    }
    
    func removeLastString(_ str: String) -> String {
        if str != "" && str != "No Data" {
            let strResult = String(str.dropLast(2)) //마지막 ,과 공백 제거
            return strResult
        }
        return str
    }
}
