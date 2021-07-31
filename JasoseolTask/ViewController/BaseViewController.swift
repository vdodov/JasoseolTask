//
//  BaseViewController.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/28.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func setNavigationTitle(_ title: String) {
        self.title = title
    }
}
