//
//  Api.swift
//  Broaden
//
//  Created by Adam Szczygiel on 07/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//

import Foundation

class API {
    
    let global = Global()
    
    func topHeadlinesBBCNews() -> URL? {
        global.topHeadLinesUrl?.queryItems?.append(global.sourcesName)
        global.topHeadLinesUrl?.queryItems?.append(global.newsAPIKey)
        return global.topHeadLinesUrl?.url
    }
}
