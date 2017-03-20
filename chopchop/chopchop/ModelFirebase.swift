//
//  ModelFirebase.swift
//  chopchop
//
//  Created by Maor Eini on 18/03/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


class ModelFirebase{
    
    init(){
        FIRApp.configure()
    }
    
    
    func registerUser(name: String, email: String, password: String, complition: @escaping (User?) -> ()) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error as Any)
                complition(nil)
                return
            }
            
            guard let uid = user?.uid else {
                complition(nil)
                return
            }
            
            complition(User(id: uid, name: name, email: email))
            
        })
    }
    
    func signInUser(name: String, email: String, password: String, completionBlock: @escaping (User?) -> ()) {
        
        var userId : String? = nil
        var signedInUser : User? = nil
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                completionBlock(nil)
                return
            }
            
            userId = user?.uid
            
            self.getUserById(id: (userId)!, callback: { (userRecord) in
                signedInUser = userRecord
                completionBlock(signedInUser)
            })

        })
    }
    
    func addUser(u:User, completionBlock:@escaping (Error?)->Void){
        let ref = FIRDatabase.database().reference().child("users").child(u.id)
        ref.setValue(u.toFirebase())
        ref.setValue(u.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    func getUserById(id:String, callback:@escaping (User)->Void){
        let ref = FIRDatabase.database().reference().child("users").child(id)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let json = snapshot.value as? Dictionary<String,Any>
            let u = User(json: json!)
            callback(u)
        })
    }
    
    func getAllUsers(_ lastUpdateDate:Date? , callback:@escaping ([User])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var users = [User]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let u = User(json: json)
                        users.append(u)
                    }
                }
            }
            callback(users)
        }
        
        let ref = FIRDatabase.database().reference().child("users")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
    
    func getAllUsersAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([User])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var users = [User]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let u = User(json: json)
                        users.append(u)
                    }
                }
            }
            callback(users)
        }
        
        let ref = FIRDatabase.database().reference().child("users")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(FIRDataEventType.value, with: handler)
        }else{
            ref.observe(FIRDataEventType.value, with: handler)
        }
    }
    
    func addFeedItem(fi:FeedItem, completionBlock:@escaping (Error?)->Void){
        let key = FIRDatabase.database().reference().child("feedItems").childByAutoId().key
        let ref = FIRDatabase.database().reference().child("feedItems").child(key)
        ref.setValue(fi.toFirebase())
        ref.setValue(fi.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    func getFeedItemById(id:String, callback:@escaping (FeedItem)->Void){
        let ref = FIRDatabase.database().reference().child("feedItems").child(id)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let json = snapshot.value as? Dictionary<String,Any>
            let fi = FeedItem(json: json!)
            callback(fi)
        })
    }
    
    func getAllFeedItems(_ lastUpdateDate:Date? , callback:@escaping ([FeedItem])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var feedItems = [FeedItem]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let fi = FeedItem(json: json)
                        feedItems.append(fi)
                    }
                }
            }
            callback(feedItems)
        }
        
        let ref = FIRDatabase.database().reference().child("feedItems")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
    
    func getAllFeedItemsAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([FeedItem])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var feedItems = [FeedItem]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let fi = FeedItem(json: json)
                        feedItems.append(fi)
                    }
                }
            }
            callback(feedItems)
        }
        
        let ref = FIRDatabase.database().reference().child("feedItems")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(FIRDataEventType.value, with: handler)
        }else{
            ref.observe(FIRDataEventType.value, with: handler)
        }
    }
    

    
    
    lazy var storageRef = FIRStorage.storage().reference(forURL:
        "gs://chopchop-8be92.appspot.com/")
    
    func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = storageRef.child(name)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.put(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = FIRStorage.storage().reference(forURL: url)
        ref.data(withMaxSize: 10000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }
    
}
