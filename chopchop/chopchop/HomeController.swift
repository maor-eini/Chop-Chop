//
//  HomeController.swift
//  chopchop
//
//  Created by Sapir Levy on 12/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UITableViewController {
    
    var feedItems = [FeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(HomeController.feedItemsListDidUpdate),
                                               name: NSNotification.Name(rawValue: notifyFeedItemListUpdate),object: nil)
        
        Model.instance.getAllFeedItemsAndObserve()
    }
    
    @objc func feedItemsListDidUpdate(notification:NSNotification){
        feedItems = notification.userInfo?["feedItems"] as! [FeedItem]
        self.tableView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FeedTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FeedTableViewCell else{
            fatalError("Error with cell type")
        }
        
        let feedItem = feedItems[indexPath.row]
        
        cell.userNameLabel.text = feedItem.author
        cell.locationLabel.text = feedItem.location
        cell.likesCount.text = String(feedItem.likesCount)
        cell.isLikeClicked = feedItem.isLikeClicked
        
        Model.instance.getImage(urlStr: feedItem.imageUrl, callback: { (image) in
            cell.foodImage!.image = image
        })
        
        if(cell.isLikeClicked == true){
            cell.likeButton.setImage(cell.likeImg, for: UIControlState.normal)
        }
        
        cell.feed = feedItem
        
        return cell
    }

    
    
    //MARK: Actions
    
    @IBAction func unwindToFeed(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? UploadPhotoViewController ,let feed = sourceViewController.feed{
            
            //add new feed 
            let newIndexPath = IndexPath(row: feedItems.count, section: 0)
            feedItems.append(feed)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }

    }
    
 

}
