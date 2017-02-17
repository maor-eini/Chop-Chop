//
//  FeedTableViewCell.swift
//  chopchop
//
//  Created by Sapir Levy on 13/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    
    //MARK: Like Button
    @IBOutlet weak var likeButton: UIButton!
    var likeImg = UIImage(named: "fullHeart")
    var unlikeImg = UIImage(named: "emptyHeart")
    
    var isLikeClicked: Bool!
    var feed: FeedItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        isLikeClicked = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        // Configure the view for the selected state
    }
    
    //MARK: button action

    @IBAction func likeButtonPressed(_ sender: Any) {
        
        isLikeClicked = !(isLikeClicked)
        
        if(isLikeClicked == true){
            likeButton.setImage(likeImg, for: UIControlState.normal)
            likesCount.text = String(Int(likesCount.text!)! + 1)
        }
        else{
            likeButton.setImage(unlikeImg, for: UIControlState.normal)
            likesCount.text = String(Int(likesCount.text!)! - 1)
        }
        
    }

}
