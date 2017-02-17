//
//  AuthService.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation
import Firebase

class ChopchopAuthService {
    
    static func registerUser(name: String, email: String, password: String, complition: @escaping (Bool) -> ()) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error as Any)
                complition(false)
                return
            }
            
            guard let uid = user?.uid else {
                complition(false)
                return
            }
            
            //succesfully authenticated user
            ChopchopDataService.sharedInstance.addUser(uid: uid, name: name, email: email) {
                result in
                if result {
                    complition(true)
                } else {
                    complition(false)
                }
            }
            
        })
    }
    
    static func signInUser(email: String, password: String, completion: @escaping (Bool) -> ()) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                completion(false)
                return
            }
            
            //successfully logged in our user
            completion(true)
            
        })
    }
}
