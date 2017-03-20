//
//  User.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User {
    var id: String
    var name: String
    var email: String
    var lastUpdate:Date?
    
    init(id: String, name: String, email: String){
        self.id = id
        self.name = name
        self.email = email
    }
    
    init(json:Dictionary<String,Any>){
        id = json["id"] as! String
        name = json["name"] as! String
        if let lu = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(lu)
        }
        email = json["email"] as! String
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["id"] = id
        json["name"] = name
        json["email"] = email
        json["lastUpdate"] = FIRServerValue.timestamp()
        return json
    }
}
