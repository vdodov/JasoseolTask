//
//  MovieListViewController.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/27.
//

import UIKit
import SnapKit

class MovieListViewController: BaseViewController {
    
    //MARK: -Properties
    private let shared = MovieModelManager.shared
    
    let searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.isHidden = false
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        return searchController
    }()
    
    let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle("네이버 영화 검색")
        configSearchBar()
        configTableView()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTableView.reloadData()
    }
    
    
    //MARK: -Action
    @objc func addTapped() {
        let likeVC = LikeViewController()
        navigationController?.pushViewController(likeVC, animated: false)
    }
    
    
    //MARK: -Functions
    private func configSearchBar() {
                
        navigationItem.searchController = searchController
        
        let rightBarButtonIamge = UIImage(named: "star")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonIamge, style: .plain, target: self, action: #selector(addTapped))
    
        searchController.searchBar.delegate = self
    }
    
    private func configTableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
        
        listTableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
    }
    
    private func configUI() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        listTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(guide)
        }
    }
    
    private func setLike(_ key: String) {
        guard let movieCount = shared.movieDataArr[key]?.items?.count else { return }

        for i in 0..<movieCount {
            shared.movieDataArr[key]?.items?[i].isLiked = false
        }
    }
    
    private func getMovie(_ searchText: String) {
        let url = "https://openapi.naver.com/v1/search/movie.json?query=" + searchText
        
        SearchAPI.getMovieData(url) { result in
            switch result {
            case .success(let data):
                self.newMovieDataArr(searchText, data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func newMovieDataArr(_ searchText: String, _ data: Item) {
        
        //키값 대문자로 저장
        let upperSearchText = searchText.uppercased()
        if !shared.movieDataArr.keys.contains(upperSearchText) { //배열에 추가
            shared.movieDataArr.updateValue(data, forKey: upperSearchText)
            setLike(upperSearchText)
        }
        listTableView.reloadData()
    }
}

//MARK: -UISearchBarDelegate
extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        
        shared.key = searchText.uppercased()
        self.getMovie(searchText)
    }
}

//MARK: -UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shared.movieDataArr[shared.key]?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell {
            let movieContent = shared.movieDataArr[shared.key]?.items?[indexPath.row]
            cell.content = movieContent
            cell.setLikeButton(movieContent?.isLiked)
            cell.index = indexPath.row
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: -UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieContent = shared.movieDataArr[shared.key]?.items?[indexPath.row]
        
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieInfoView.index = indexPath.row
        movieDetailVC.setData(movieContent?.title, movieContent?.link)
        movieDetailVC.movieInfoView.content = movieContent
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

