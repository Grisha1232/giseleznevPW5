//
//  NewsViewController.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 12/7/22.
//

import UIKit

final class NewsViewController: UIViewController {
    private let imageView = UIImageView()
    private let authorLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupImageView()
        setupAuthorLabel()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    private func setupNavBar() {
        navigationItem.title = "News"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setupImageView() {
        imageView.image = UIImage(named: "landscape")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.pin(to: view, [.left, .right])
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
    }
    
    private func setupAuthorLabel() {
        authorLabel.font = .systemFont(ofSize: 15, weight: .light)
        authorLabel.numberOfLines = 0
        authorLabel.textColor = .secondaryLabel
        
        view.addSubview(authorLabel)
        
        authorLabel.pinTop(to: imageView.bottomAnchor, 12)
        authorLabel.pin(to: view, [.left: 16, .right: 16])
        authorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        
        view.addSubview(titleLabel)
        
        titleLabel.pinTop(to: authorLabel.bottomAnchor, 12)
        titleLabel.pin(to: view, [.left: 16, .right: 16])
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .light)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        
        view.addSubview(descriptionLabel)
        descriptionLabel.pin(to: view, [.left: 16, .right: 16])
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public func configure(with viewModel: NewsViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        authorLabel.text = viewModel.author
        guard let url = viewModel.urlToImage else { return }
        
        getData(from: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
        
    }
}
