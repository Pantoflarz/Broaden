//
//  News.swift
//  Broaden
//
//  Created by Adam Szczygiel on 06/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//

import UIKit

struct NewsSource: Codable {
    let status: String?
    let totalResults: Int?
    struct Article: Codable {
        let source: Source
        let author: String?
        let title: String?
        let description: String?
        let url: URL?
        let urlToImage: URL?
        let publishedAt: Date
        
        struct Source: Codable {
            let id: String?
            let name: String?
        }
    }
    
    let articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}
