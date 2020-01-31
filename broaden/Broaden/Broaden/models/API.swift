//
//  Api.swift
//  Broaden
//
//  Created by Adam Szczygiel on 07/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//

import UIKit

class API {

    let global = Global()
    var feed: [NewsSource.Article] = []
    var lastRetrieved : Double = 0
    
    var errorMessage = ""
    
    func topHeadlines() -> URL? {
        global.topHeadLinesUrl?.queryItems?.append(global.sourcesName)
        global.topHeadLinesUrl?.queryItems?.append(global.pageSize)
        global.topHeadLinesUrl?.queryItems?.append(global.newsAPIKey)
        return global.topHeadLinesUrl?.url
    }

    fileprivate func updateResults(_ data: Data) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode date string \(dateString)")
        }
        feed.removeAll()
        do {
            let rawFeed = try decoder.decode(NewsSource.self, from: data)
            feed = rawFeed.articles
            lastRetrieved = NSDate().timeIntervalSince1970
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError)"
            return
        }
    }
    
    func getResults(from url: URL, completion: @escaping () -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard let data = data else { return }
            self.updateResults(data)
            completion()
            }.resume()
    }

}
