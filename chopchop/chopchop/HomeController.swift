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
        feedItems = ChopchopDataService.sharedInstance.getFeedItems()
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
        print(feedItems)
        let feedItem = feedItems[indexPath.row]
        
        cell.userNameLabel.text = feedItem.author
        cell.locationLabel.text = feedItem.location
        
        cell.foodImage.image = feedItem.image
        
        cell.likesCount.text = String(feedItem.likesCount)
        cell.isLikeClicked = feedItem.isLikeClicked
        
        if(cell.isLikeClicked == true){
            cell.likeButton.setImage(cell.likeImg, for: UIControlState.normal)
        }
        
        cell.feed = feedItem
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Actions
    
    @IBAction func unwindToFeed(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? UploadPhotoViewController ,let feed = sourceViewController.feed{
            
            //add new feed 
            let newIndexPath = IndexPath(row: feedItems.count, section: 0)
            feedItems.append(feed)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }

    }
    
    
    //MARK: Private Methods
    
    private func loadSampleFeed(){
        
        /*
        print("hello")
        
        let photo = UIImage(named: "default")
        guard let item1 = FeedItem(name: "Sapir Levy", image: photo, location: "was in Angelina Hod HaSharon", likesCount: 10 , isLikeClicked: true) else{
            fatalError("item1")
        }
        
        guard let item2 = FeedItem(name: "Maor Eini", image: photo, location: "was in Angelina Hod HaSharon" , likesCount: 5, isLikeClicked: false)else{
            fatalError("item2")
        }
        
        guard let item3 = FeedItem(name: "Lucas", image: photo, location: "was in Angelina Hod HaSharon" , likesCount: 1, isLikeClicked: true) else{
                fatalError("item3")
        }
        
        names += [item1 , item2 , item3]
            */
    }
 

}
