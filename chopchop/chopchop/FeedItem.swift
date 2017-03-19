//
//  Post.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedItem {
    var id: String
    var userId: String
    var date: Date
    var author: String
    var imageUrl: String
    var location: String
    var likesCount: Int
    var isLikeClicked: Bool
    var lastUpdate : Date?
    
    init(id: String, userId: String, author: String, date: Date, imageUrl: String, location: String, likesCount: Int, isLikeClicked: Bool) {
        self.id = id
        self.userId = userId
        self.date = date
        self.author = author
        self.imageUrl = imageUrl
        self.location = location
        self.likesCount = likesCount
        self.isLikeClicked = isLikeClicked
    }
    
    init(json:Dictionary<String,Any>){
        self.id = json["id"] as! String
        self.userId = json["userId"] as! String
        self.date = Date(timeIntervalSince1970: (json["date"] as! Double))
        self.author = json["author"] as! String
        self.imageUrl = json["imageUrl"] as! String
        self.location = json["location"] as! String
        self.likesCount = json["likesCount"] as! Int
        self.isLikeClicked = (json["isLikeClicked"] as! Int == 1) ? true : false;
        if let lu = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(lu)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["id"] = id
        json["userId"] = userId
        json["date"] = date.timeIntervalSince1970
        json["author"] = author
        json["imageUrl"] = imageUrl
        json["location"] = location
        json["likesCount"] = likesCount
        json["isLikeClicked"] = isLikeClicked ? 1 : 0
        json["lastUpdate"] = FIRServerValue.timestamp()
        return json
    }
}
