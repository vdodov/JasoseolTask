//
//  MovieCell.swift
//  JasoseolTask
//
//  Created by 차수연 on 2021/07/27.
//

import UIKit
import SnapKit
import Kingfisher

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"
    
    //MARK: -Properties
    private let shared = MovieModelManager.shared
    
    var index = 0
    
    var content: Movie? {
        didSet { setupData() }
    }
    
    private let thumbnailImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .systemGroupedBackground
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "영화 타이틀"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let directorLabel: UILabel = {
       let label = UILabel()
        label.text = "감독"
        return label
    }()
    
    private let actorLabel: UILabel = {
       let label = UILabel()
        label.text = "출연진"
        return label
    }()
    
    private let userRatingLabel: UILabel = {
       let label = UILabel()
        label.text = "평점"
        return label
    }()
    
    private var infoStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let likeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    //MARK: -Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        configUI()
        likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
    }
    
    //MARK: -Action
    @objc func didTapLikeButton(_ sender: UIButton) {
        guard let movieContent = shared.movieDataArr[shared.key]?.items?[index] else { return }
        guard let isLiked = movieContent.isLiked else { return }
        
        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "empty_star"), for: .normal)
            
            guard let currentLink = shared.movieDataArr[shared.key]?.items?[index].link else { return }
            
            var removeIndex = 0
            for i in 0..<shared.likeMoiveDataArr.count {
                if currentLink == shared.likeMoiveDataArr[i].link {
                    shared.movieDataArr[shared.key]?.items?[index].isLiked = false
                    removeIndex = i
                }
            }
            
            shared.likeMoiveDataArr.remove(at: removeIndex)
        } else {
            shared.movieDataArr[shared.key]?.items?[index].isLiked = true
            likeButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            shared.likeMoiveDataArr.append(Movie(title: movieContent.title,
                                                 link: movieContent.link,
                                                 image: movieContent.image,
                                                 director: movieContent.director,
                                                 actor: movieContent.actor,
                                                 userRating: movieContent.userRating,
                                                 isLiked: shared.movieDataArr[shared.key]?.items?[index].isLiked ))
        }
    }
    
    //MARK: -Functions
    func configUI() {
        let margin: CGFloat = 10
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(1.5)
            make.top.leading.equalToSuperview().offset(margin)
            make.bottom.equalToSuperview().offset(-margin)
        }
        
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
        }
        
        setupStackView()
        contentView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView).offset(margin)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(margin)
            make.trailing.equalTo(likeButton.snp.leading).offset(-margin)
            make.bottom.equalTo(thumbnailImageView).offset(-margin)
        }
        
    }
    
    private func setupStackView() {
        infoStackView = UIStackView(arrangedSubviews: [titleLabel, directorLabel, actorLabel, userRatingLabel])
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .equalSpacing
    }
    
    private func setupData() {
        downloadIamge(content?.image)
        
        titleLabel.text = String().checkString(content?.title)
        let director = String().checkString(content?.director)
        directorLabel.text = "감독: " + String().removeLastString(director)
        let actor = String().checkString(content?.actor)
        actorLabel.text = "출연: " + String().removeLastString(actor)
        userRatingLabel.text = "평점: " + String().checkString(content?.userRating)
    }
    
    func setLikeButton(_ isLiked: Bool?) {
        guard let isLiked = isLiked else { return }
        
        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "empty_star"), for: .normal)
        }
        
    }
    
    private func downloadIamge(_ str: String?) {
        guard let str = str else {
            thumbnailImageView.image = #imageLiteral(resourceName: "default-image")
            return
        }
        
        if str == "" {
            thumbnailImageView.image = #imageLiteral(resourceName: "default-image")
        }
        
        guard let url = URL(string: str) else { return }
        thumbnailImageView.kf.setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

