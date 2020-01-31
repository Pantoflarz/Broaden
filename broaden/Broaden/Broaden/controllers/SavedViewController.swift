//
//  SecondViewController.swift
//  Broaden
//
//  Created by Adam Szczygiel on 05/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//

import UIKit
import SafariServices

struct SavedArticle {
    var title : String
}

class SavedArticleTableViewCell: UITableViewCell{
    @IBOutlet weak var savedArticleTitleLabel: UILabel!
}

class SavedViewController: UITableViewController, UIGestureRecognizerDelegate {

    let user = User()

    @IBOutlet var tableview: UITableView!
    @IBOutlet var nodataview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture = UILongPressGestureRecognizer(target:self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.tableview.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer){
        let p = longPressGesture.location(in: self.tableview)
        let indexPath = self.tableview.indexPathForRow(at: p)
        if longPressGesture.state == UILongPressGestureRecognizer.State.began{
            
            var sortedkeys = Array(user.getSavedArticles().keys)
            let headline = sortedkeys[indexPath!.item]
            
            let alert = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete from Saved", style: .default) { action -> Void in
                self.user.deleteFromSavedArticles(title: headline)
                self.tableview.reloadData()
            })
            alert.addAction(UIAlertAction(title: "Copy URL to Clipboard", style: .default) { action -> Void in
                UIPasteboard.general.string = self.user.getSavedArticleURL(title: headline)
            })
            
            self.present(alert, animated:true)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableview.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = user.getSavedArticles().count
        
        if count == 0{
            self.tableview.backgroundView = nodataview
        }else{
            self.tableview.backgroundView = nil
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedarticlecell", for: indexPath) as! SavedArticleTableViewCell
        
        var sortedkeys = Array(user.getSavedArticles().keys)
        
        let headline = sortedkeys[indexPath.item]

        cell.savedArticleTitleLabel.text = headline
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sortedkeys = Array(user.getSavedArticles().keys)
        let headline = sortedkeys[indexPath.item]
        openSafariLink(link: self.user.getSavedArticleURL(title: headline))
    }

    private func openSafariLink(link: String){
        if let link = URL(string: link){
            let myrequest = SFSafariViewController(url: link)
            present(myrequest, animated:true)
        }
    }
}

