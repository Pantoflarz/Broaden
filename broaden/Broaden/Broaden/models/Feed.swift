//
//  Feed.swift
//  Broaden
//
//  Created by Adam Szczygiel on 07/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//

import UIKit

class Feed{
    
    let app = App()
    let user = User()
    let global = Global()
    let api = API()
    
    var feed: [NewsSource.Article] = []
    
    func getPersonalisedFeed(news: [NewsSource.Article]) -> [NewsSource.Article]{

        self.feed.removeAll()
        
        let positionOfUserPoliticalLeaningInSpectrum = global.politicalSpectrum.firstIndex(of: user.getPoliticalLeaning()) ?? 0
        
        for source in global.politicalSpectrumSourcesApiNames[positionOfUserPoliticalLeaningInSpectrum]{
            for article in news{
                if(String(article.source.name!) == String(source)){
                    self.feed.append(article)
                }
            }
        }
        
        var temporaryOtherFeed: [NewsSource.Article] = []
        
        for index in 1...5{
            if(index != positionOfUserPoliticalLeaningInSpectrum){
                for source in global.politicalSpectrumSourcesApiNames[index]{
                    for article in news{
                        if(String(article.source.name!) == String(source)){
                            temporaryOtherFeed.append(article)
                        }
                    }
                }
            }
        }

        for index in 1...Int(self.calculatePercentage(value: Double(feed.count), percentageVal: 50)){
            var random = Int.random(in:0..<temporaryOtherFeed.count)
           self.feed.append(temporaryOtherFeed[random])
        }
        
        self.feed.shuffle()
        return self.feed
        
    }
    
    func getNewsArticlePositionInPoliticalSpectrum(article: NewsSource.Article) -> Int{
        for(index, sources) in global.politicalSpectrumSourcesApiNames.enumerated(){
            if sources.contains(String(article.source.name!)){
                return index
            }
        }
        return -1
    }
    
    private func calculatePercentage(value: Double, percentageVal: Double)->Double{
        
        let val = value * percentageVal
        return round(val / 100)
    }
}
