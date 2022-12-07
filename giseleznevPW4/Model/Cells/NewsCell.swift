//
//  NewsCell.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 12/7/22.
//

import UIKit

final class NewsCell: UITableViewCell {
    static let reuseIdentifier = "NewsCell"
    
    private let newsImageView = UIImageView()
    private let imageLayer = CAGradientLayer()
    
    let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
    
    public func configure(with news: NewsViewModel) {
        newsTitleLabel.text = news.title
        newsDescriptionLabel.text = news.description
        newsImageView.image = UIImage(systemName: "figure.walk")
        newsImageView.tintColor = .label
        if let data = news.imageData {
            newsImageView.image = UIImage(data: data)
            imageLayer.removeAnimation(forKey: "backgroundColor")
        } else if let url = news.urlToImage {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    news.imageData = data
                    self?.newsImageView.image = UIImage(data: data)
                    guard let layer = self?.imageLayer else {return}
                    layer.removeAnimation(forKey: "backgroundColor")
                }
            }.resume()
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageLayer.frame = newsImageView.bounds
        imageLayer.cornerRadius = 10
    }
    
    private func deleteSubLayer() {
        for sub in newsImageView.layer.sublayers ?? [] {
            if sub == imageLayer {
                newsImageView.layer.replaceSublayer(imageLayer, with: CAGradientLayer())
            }
        }
    }
    
    private func setupView() {
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    private func setupImageView() {
        
        imageLayer.startPoint = CGPoint(x: 0, y: 0.5)
        imageLayer.endPoint = CGPoint(x: 1, y: 0.5)
        newsImageView.layer.addSublayer(imageLayer)
        
        newsImageView.image = UIImage(systemName: "SOS")
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.backgroundColor = .secondarySystemBackground
        
        let imageGroup = makeAnimationGroup()
        imageGroup.beginTime = 0
        imageLayer.add(imageGroup, forKey: "backgroundColor")
        
        contentView.addSubview(newsImageView)
        
        newsImageView.pin(to: contentView, [.top: 12, .left: 16, .bottom: 12])
        newsImageView.pinWidth(to: newsImageView.heightAnchor)
    }
    
    private func setupTitleLabel() {
        newsTitleLabel.text = "Hello"
        newsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.numberOfLines = 1
        
        contentView.addSubview(newsTitleLabel)
        
        newsTitleLabel.pinLeft(to: newsImageView.trailingAnchor, 12)
        newsTitleLabel.heightAnchor.constraint(equalToConstant:newsTitleLabel.font.lineHeight).isActive = true
        newsTitleLabel.pinTop(to: contentView.topAnchor, 12)
        newsTitleLabel.pinRight(to: contentView.trailingAnchor, 12)
    }
    
    private func setupDescriptionLabel() {
        newsDescriptionLabel.text = "World"
        newsDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 0
        
        contentView.addSubview(newsDescriptionLabel)
        
        newsDescriptionLabel.pinTop(to: newsTitleLabel.bottomAnchor, 12)
        newsDescriptionLabel.pinLeft(to: newsImageView.trailingAnchor, 12)
        newsDescriptionLabel.pinRight(to: contentView.trailingAnchor, 16)
        newsDescriptionLabel.pinBottom(to: contentView.bottomAnchor, 12)
    }
    private func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1.5
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.lightGray.cgColor
        anim1.toValue = UIColor.darkGray.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0

        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.darkGray.cgColor
        anim2.toValue = UIColor.lightGray.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude // infinite
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false

        if let previousGroup = previousGroup {
            // Offset groups by 0.33 seconds for effect
            group.beginTime = previousGroup.beginTime + 0.1
        }

        return group
    }
}
