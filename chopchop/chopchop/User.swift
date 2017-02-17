//
//  User.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation

class User {
    var userId: String
    var name: String
    var email: String
    
    init(userId: String, name: String, email: String, text: String){
        self.userId = userId
        self.name = name
        self.email = email
    }
}
