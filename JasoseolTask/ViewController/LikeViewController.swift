//
//  LikeViewController.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/27.
//

import UIKit
import SnapKit

class LikeViewController: BaseViewController {
    
    //MARK: -Properties
    private let shared = MovieModelManager.shared
    
    let listTableView: UITableView = {
       let tableView = UITableView()
        return tableView
    }()

    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle("즐겨찾기 목록")
        configTableView()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTableView.reloadData()
    }
    
    //MARK: -Functions
    private func configTableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
        
        listTableView.register(LikeMovieCell.self, forCellReuseIdentifier: LikeMovieCell.identifier)
    }
    
    private func configUI() {
        view.addSubview(listTableView)
        
        let guide = view.safeAreaLayoutGuide
        listTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(guide)
        }
    }
    
    private func changeIsLikedValue(_ index: Int) {
        //삭제할 영화 링크값
        guard let currentLink = shared.likeMoiveDataArr[index].link else { return }
        
        let keys = Array(shared.movieDataArr.keys)
        
        for i in 0..<keys.count {
            let key = keys[i]
            guard let items = shared.movieDataArr[key]?.items else { return }
            
            for j in 0..<items.count {
                //링크 값이 같으면 isLiked 값 false로 변경
                if currentLink == items[j].link {
                    shared.movieDataArr[key]?.items?[j].isLiked = false
                }
            }
        }
        
    }
}

//MARK: -UITableViewDataSource
extension LikeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shared.likeMoiveDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LikeMovieCell.identifier, for: indexPath) as? LikeMovieCell {
        
            cell.index = indexPath.row
            cell.content = shared.likeMoiveDataArr[indexPath.row]
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: -UITableViewDelegate
extension LikeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieContent = self.shared.likeMoiveDataArr[indexPath.row]
        
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieInfoView.index = indexPath.row
        movieDetailVC.setData(movieContent.title, movieContent.link)
        movieDetailVC.movieInfoView.content = movieContent
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

//MARK: -LikeMovieCellDelegate
extension LikeViewController: LikeMovieCellDelegate {
    func didTapLikeButton(_ index: Int) {
        
        self.changeIsLikedValue(index)
        shared.likeMoiveDataArr.remove(at: index)
        
        listTableView.reloadData()
    }
}
