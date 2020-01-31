//
//  User.swift
//  Broaden
//
//  Created by Adam Szczygiel on 05/11/2019.
//  Copyright © 2019 broaden. All rights reserved.
//  A User class to hold all the information about a user (currently this is done locally, but could well be done via a remote server - the reason this model exists, is that such a change could be easily implemented without breaking the controllers and views.
//

import UIKit

class User {
    
    //we are using userDefaults for storage purposes
    let defaults = UserDefaults.standard
    
    //function to remove the given object at the given key from storage
    func purge(key: String){
        defaults.removeObject(forKey: key)
    }
    
    //function to check if a given value is set in storage
    func isset(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //getter, setter and purger methods for political leaning
    func getPoliticalLeaning() -> String {
        if let savedPoliticalLeaning = defaults.string(forKey: "UserPoliticalLeaning") {
            return savedPoliticalLeaning
        }else{
            return ""
        }
    }
    
    func savePoliticalLeaning(leaning: String){
        if(leaning != ""){
            defaults.set(leaning, forKey: "UserPoliticalLeaning")
        }
    }

    func purgePoliticalLeaning(){
        self.purge(key: "UserPoliticalLeaning")
    }
    
    //getter, saver and purger for news feed
    func getNewsFeed() -> [NewsSource.Article]{
        if let savedNewsFeed = defaults.object(forKey: "UserNewsFeed") as? [NewsSource.Article] {
            return savedNewsFeed
        }else{
            return [NewsSource.Article]()
        }
    }
    
    func saveNewsFeed(feed: [NewsSource.Article] = []){
        defaults.set(feed, forKey: "UserNewsFeed")
    }
    
    func purgeNewsFeed(){
        self.purge(key: "UserNewsFeed")
    }
    //getter, saver, deleter and purger for saved articles
    
    func getSavedArticleURL(title: String) -> String{
        var savedArticles = self.getSavedArticles()
        return savedArticles[title]!
    }
    
    func getSavedArticles() -> [String: String] {
        if let savedArticles = defaults.object(forKey: "UserSavedArticles") as? [String: String] {
            return savedArticles
        }else{
            return [String: String]()
        }
    }
    
    func addToSavedArticles(url: String, title: String){
        var savedArticles = self.getSavedArticles()
        savedArticles.updateValue(url, forKey: title)
        defaults.set(savedArticles, forKey: "UserSavedArticles")
    }
    
    func deleteFromSavedArticles(title: String){
        var savedArticles = self.getSavedArticles()
        savedArticles.removeValue(forKey: title)
        defaults.set(savedArticles, forKey: "UserSavedArticles")
    }
    
    func purgeAllSavedArticles(){
        self.purge(key: "UserSavedArticles")
    }
    
    //getter, saver and adder for user statistics
    func getPoliticalSpectrumUserReadingStats() -> [Int]{
        if let statistics = defaults.object(forKey: "UserReadingStats") {
            return statistics as! [Int]
        }else{
            //return empty stats as the user hasnt read any article yet
            return [0, 0, 0, 0, 0, 0]
        }
    }
    
    func savePoliticalSpectrumUserReadingStats(statistics: [Int]){
        defaults.set(statistics, forKey: "UserReadingStats")
    }
    
    func addToPoliticalSpectrumUserReadingStats(index: Int){
        var statistics = self.getPoliticalSpectrumUserReadingStats()
        statistics[index] = statistics[index]+1
        self.savePoliticalSpectrumUserReadingStats(statistics: statistics)
    }
    
}
