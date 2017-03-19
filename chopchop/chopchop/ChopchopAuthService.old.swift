//
//  AuthService.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation
import Firebase

class ChopchopAuthService2 {
    
    static var currentUser : User? = nil
    
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
            
            currentUser = User(id: uid, name: name, email: email)
            
            //succesfully authenticated user
            Model.instance.addUser(u: currentUser!)
        })
    }
    
    static func signInUser(name: String, email: String, password: String, completion: @escaping (Bool) -> ()) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                completion(false)
                return
            }
            
            Model.instance.getUserById(id: (user?.uid)!, callback: { (_currentUser) in
                currentUser = _currentUser
            })
            
            //successfully logged in our user
            completion(true)
            
        })
    }
}
