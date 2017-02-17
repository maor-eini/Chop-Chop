//
//  Post.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit

class FeedItem {
    var userId: String
    var date: String
    var author: String
    var imageUrl: String
    var location: String
    var likesCount: Int
    var isLikeClicked: Bool
    var image : UIImage
    
    init(userId: String, author: String, date: String, imageUrl: String, location: String, likesCount: Int, isLikeClicked: Bool) {
        self.userId = userId
        self.date = date
        self.author = author
        self.imageUrl = imageUrl
        self.location = location
        self.likesCount = likesCount
        self.isLikeClicked = isLikeClicked
        self.image = UIImage()
        
    }
}
