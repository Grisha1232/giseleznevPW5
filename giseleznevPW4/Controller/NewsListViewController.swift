//
//  NewsListViewController.swift
//  giseleznevPW5
//
//  Created by Григорий Селезнев on 12/7/22.
//

import UIKit

final class NewsListViewController : UIViewController {
    private final let apiKey = "87ff1b5571554cd1883e2a931de91470"
    private var selectedCountry = "ru"
    private let availableCountry = ["ru", "us"]
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false;
    private var newsViewModels = [
        NewsViewModel(id: nil, name: nil, author: nil, title: "1", description: "1",
                      url: nil, image: nil, publishedAt: nil, content: nil),
        NewsViewModel(id: nil, name: nil, author: nil, title: "1", description: "1",
                      url: nil, image: nil, publishedAt: nil, content: nil),
        NewsViewModel(id: nil, name: nil, author: nil, title: "1", description: "1",
                      url: nil, image: nil, publishedAt: nil, content: nil),
        NewsViewModel(id: nil, name: nil, author: nil, title: "1", description: "1",
                      url: nil, image: nil, publishedAt: nil, content: nil)]
    private var NewsCells: [NewsCell] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchNews()
    }
    
    // MARK: setupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setTableVIewUI()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Articles"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        let country = UIBarButtonItem(
            title: selectedCountry,
            style: .plain,
            target: self,
            action: #selector(changeCountry)
        )
        country.tintColor = .label
        
        let reload = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(reloadData)
        )
        
        reload.tintColor = .label
        
        navigationItem.rightBarButtonItems = [country, reload]
        
    
    }
    @objc private func reloadData() {
        newsViewModels = []
        fetchNews()
    }
    
    
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableVIewUI() {
        view.addSubview(tableView)
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        setTableViewDelegate()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    
    // MARK: get data for news
    private func fetchNews() {
        isLoading = true
        tableView.reloadData()
        guard let urlRequest = URL(string: "https://newsapi.org/v2/top-headlines?country=" + selectedCountry + "&apiKey=" + apiKey) else { print("cannot get data from url"); return }
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.isLoading = true
            DispatchQueue.main.async {
                if let data = data,
                   let result = try? JSONDecoder().decode(ResponseModel.self, from: data) {
                    self?.newsViewModels = result.articles
                }
                
                self?.isLoading = false
                self?.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    // MARK: Objc func
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeCountry() {
        if (selectedCountry == availableCountry[0]) {
            selectedCountry = availableCountry[1]
        } else {
            selectedCountry = availableCountry[0]
        }
        navigationItem.rightBarButtonItem?.title = selectedCountry
        fetchNews()
    }
}

// MARK: DataSource (TableView)
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 4
        } else {
            return newsViewModels.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            return SkeletonCell()
        } else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell {
                newsCell.configure(with: viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
    
    
}

// MARK: Delegate (TableView)
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}
