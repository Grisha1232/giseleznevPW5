//
//  ApiResponseModel.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 12/7/22.
//

import UIKit

final class ResponseModel: Decodable {
    let status: String?
    let totalResults: Int?
    public let articles: [NewsViewModel]
    
    init(status: String?, totalResults: Int?, articles: [NewsViewModel]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}
