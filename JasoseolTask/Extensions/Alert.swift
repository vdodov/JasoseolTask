//
//  Alert.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/29.
//

import UIKit

extension UIAlertController {
    func show(title:String?, message: String, from controller: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        controller.show(alert, sender: nil)
    }
}
