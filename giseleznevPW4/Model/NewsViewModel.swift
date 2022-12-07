//
//  NewsViewModel.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 12/7/22.
//

import UIKit

final class NewsViewModel: Decodable {
    let source: SourceOfNews
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    var imageData: Data?
    let publishedAt: String?
    let content: String?
    
    init(id: String?, name: String?, author: String?, title: String?, description: String?, url: URL?, image: URL?, publishedAt: String?, content: String?) {
        self.source = SourceOfNews(id: id, name: name)
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = image
        self.publishedAt = publishedAt
        self.content = content
        self.imageData = nil
    }
}

struct SourceOfNews: Decodable {
    let id: String?
    let name: String?
    init(id: String?, name: String?) {
        self.id = id ?? ""
        self.name = name
    }
}
