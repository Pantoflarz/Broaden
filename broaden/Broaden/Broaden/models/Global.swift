//
//  Global.swift
//  Broaden
//
//  Created by Adam Szczygiel on 05/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//  A Global class to hold global variables - these would be taken from a remote server in a production environment and this class is used as a simple replacement
//

import UIKit

class Global{
    
    var navigationIndexNews = 0
    var navigationIndexSaved = 1
    var navigationIndexSettings = 2

    let politicalSpectrum = ["", "Left Wing", "Leans Left", "Centrist", "Leans Right", "Right"]
    let politicalSpectrumSources = [[], ["Mirror", "Vice News"], ["Guardian", "CNN", "Metro"], ["BBC News", "Independent"], ["The Times", "Telegraph", "Sky News"], ["Daily Mail", "The Sun"]]
    let politicalSpectrumSourcesApiNames = [[], ["Mirror.co.uk", "Vice News"], ["Theguardian.com", "CNN", "Metro.co.uk"], ["BBC News", "Independent"], ["Thetimes.co.uk", "Telegraph.co.uk", "Sky.com"], ["Dailymail.co.uk", "Thesun.co.uk"]]
    
    let newsAPIKey = URLQueryItem(name: "apiKey", value: "xxx")
    
    var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
    var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
    var sourcesUrl = URLComponents(string: "https://newsapi.org/v2/sources?")
    
    let sourcesName = URLQueryItem(name: "country", value: "gb")
    let pageSize = URLQueryItem(name: "pageSize", value: "100")
}
