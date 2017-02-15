//
//  FeedItem.swift
//  chopchop
//
//  Created by Sapir Levy on 13/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit

class FeedItem {
    
    //MARK: Properties
    var userName: String
    var image: UIImage?
    var location: String
    var likesCount: Int
    var isLikeClicked: Bool
    
    init?(name: String, image:UIImage?, location: String , likesCount: Int , isLikeClicked:Bool){
        if(name.isEmpty || location.isEmpty){
            return nil
        }
        self.userName = name
        self.image = image
        self.location = location
        self.likesCount = likesCount
        self.isLikeClicked = isLikeClicked
    }
}
