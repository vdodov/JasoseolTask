//
//  MovieDetailViewController.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/27.
//

import UIKit
import SnapKit
import WebKit

class MovieDetailViewController: BaseViewController {
    
    //MARK: -Properties
    let movieInfoView: MovieInfoView = {
        let view = MovieInfoView()
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    let webView = WKWebView()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    
    //MARK: -Functions
    func setData(_ title: String?, _ linkUrl: String?) {
        
        self.title = String().checkString(title)
        loadWebPage(linkUrl!)
    }
    
    private func loadWebPage(_ url: String) {
        guard let myUrl = URL(string: url) else { return }
        let request = URLRequest(url: myUrl)
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    private func configUI() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(movieInfoView)
        movieInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(guide)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(movieInfoView.snp.bottom)
            make.leading.trailing.bottom.equalTo(guide)
        }
        
        webView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(webView)
            make.width.height.equalTo(50)
        }
    }

}

//MARK: -WKNavigationDelegate
extension MovieDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIAlertController().show(title: "", message: error.localizedDescription, from: self)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIAlertController().show(title: "", message: error.localizedDescription, from: self)
    }
}
