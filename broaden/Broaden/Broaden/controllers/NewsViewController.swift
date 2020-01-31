//
//  NewsViewController.swift
//  Broaden
//
//  Created by Adam Szczygiel on 06/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

struct Headline {
    var id : Int
    var title : String
    var text : String
    var image : String
}

class HeadlineTableViewCell: UITableViewCell{
    @IBOutlet weak var headlineImageView: UIImageView!
    @IBOutlet weak var headlineTitleLabel: UILabel!
    @IBOutlet weak var headlineDescriptionLabel: UILabel!
    
    
}

class NewsViewController: UITableViewController, UIGestureRecognizerDelegate {

    let app = App()
    let user = User()
    let global = Global()
    let api = API()
    let feed = Feed()

    var displayFeed: [NewsSource.Article] = []
    
    var webview = WKWebView()
    
    @IBOutlet var tableview: UITableView!

    fileprivate var tasks = [URLSessionTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.scrollIndicatorInsets = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left:0, bottom:0, right:0)
        
        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBar = statWindow.subviews[0] as UIView
        statusBar.backgroundColor = UIColor(red: 3 / 255.0, green: 186 / 255.0, blue: 223 / 255.0, alpha: 1)
        
        let longPressGesture = UILongPressGestureRecognizer(target:self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.tableview.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer){
        let p = longPressGesture.location(in: self.tableview)
        let indexPath = self.tableview.indexPathForRow(at: p)
        if longPressGesture.state == UILongPressGestureRecognizer.State.began{

            let alert = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save in App", style: .default) { action -> Void in
                let headline = self.feed.feed[indexPath!.item]
                self.user.addToSavedArticles(url: headline.url!.absoluteString, title: headline.title!)
            })
            alert.addAction(UIAlertAction(title: "Copy URL to Clipboard", style: .default) { action -> Void in
                let headline = self.feed.feed[indexPath!.item]
                UIPasteboard.general.url = headline.url
            })
            
            self.present(alert, animated:true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(user.getPoliticalLeaning() != ""){
            api.getResults(from: api.topHeadlines()!) {
                DispatchQueue.main.async {
                    //self.api.feed.forEach{
                    //print("Title: \($0.title ?? "No Title") - \($0.publishedAt), \($0.source.id?.capitalized ?? "null")")
                    //print("SourceURL: \(String(describing: $0.url)) Image: \(String(describing: $0.urlToImage))")
                    //}
                    self.displayFeed = self.feed.getPersonalisedFeed(news: self.api.feed)
                    self.tableview.reloadData()
                }
            }
        }else{
            self.displayFeed = []
            self.tableview.reloadData()
        }
        
        if(app.isFirstLaunch() || user.getPoliticalLeaning() == ""){
            let alert = UIAlertController(title: "Welcome!", message: "As a new user, we need you to tell us about your political views before you can use the app.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sure!", style: .default) { action -> Void in
                self.tabBarController?.selectedIndex = self.global.navigationIndexSettings
            })
            self.present(alert, animated:true)
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.feed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! HeadlineTableViewCell
        
        let headline = self.feed.feed[indexPath.item]
        
        do{
            let url = headline.urlToImage!
            let data = try Data(contentsOf: url)
            cell.headlineImageView?.image = UIImage(data: data)
        }catch{
            print(error)
        }
        
        cell.headlineTitleLabel.text = headline.title
        cell.headlineDescriptionLabel.text = headline.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let headline = self.feed.feed[indexPath.item]
        saveUserOpenedArticleWithLeaning(positionOfArticleInPoliticalSpectrum: feed.getNewsArticlePositionInPoliticalSpectrum(article: headline))
        openSafariLink(link: headline.url!.absoluteString)
    }

    private func openSafariLink(link: String){
        if let link = URL(string: link){
            let myrequest = SFSafariViewController(url: link)
            present(myrequest, animated:true)
        }
    }
    
    private func saveUserOpenedArticleWithLeaning(positionOfArticleInPoliticalSpectrum: Int){
        user.addToPoliticalSpectrumUserReadingStats(index: positionOfArticleInPoliticalSpectrum)
    }
    
}
