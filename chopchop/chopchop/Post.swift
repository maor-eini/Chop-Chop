//
//  Post.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit

class Post {
    var userId: String
    var date: String
    var author: String
    var text: String
    var imageUrl: String
    var location: String
    var likesCount: Int
    var isLikeClicked: Bool
    
    init(userId: String, author: String, date: String, text: String, imageUrl: String, location: String, likesCount: Int, isLikeClicked: Bool) {
        self.userId = userId
        self.date = date
        self.author = author
        self.text = text
        self.imageUrl = imageUrl
        self.location = location
        self.likesCount = likesCount
        self.isLikeClicked = isLikeClicked
    }
}
