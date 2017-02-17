//
//  ChopchopRepository.swift
//  chopchop
//
//  Created by Maor Eini on 16/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation
import Firebase

class ChopchopDataService {
      
    private var ref: FIRDatabaseReference? = nil

    private init() {
        ref = FIRDatabase.database().reference(fromURL: "https://chopchop-8be92.firebaseio.com/")
        ref?.keepSynced(true)
    }
    
    static let sharedInstance : ChopchopDataService = {
        let instance = ChopchopDataService()
        return instance
    }()
    
    func addUser(uid: String, name: String, email: String, completion: @escaping (Bool) -> ()) {
        
        let usersReference = ref?.child("users").child(uid)
        let values = ["name": name, "email": email]
        
        usersReference?.updateChildValues(values) { (err, ref) in
            
            if err != nil {
                print(err as Any)
                completion(false)
                return
            }
            
            completion(true)
            print("User Saved")
        }
    }
    
    func addPost(post: Post, withCompletionBlock completion: @escaping (Bool) -> ()){
        
        let key = ref?.child("posts").childByAutoId().key
        
        let post = ["uid": post.userId,
                    "author": post.author,
                    "text": post.text,
                    "date": post.date,
                    "imageUrl": post.imageUrl,
                    "location": post.location,
                    "likesCount": post.likesCount,
                    "isLikeClicked": post.isLikeClicked] as [String : Any]
        
        ref?.child(key!).updateChildValues(post)  { (err, ref) in
            
            if err != nil {
                print(err as Any)
                completion(false)
                return
            }
            completion(true)
            print("User Saved")
        }
        
    }
    
    func getPostsByUserName(userName: String) -> [Post] {
        
        var posts = [Post]()
        
        ref?.child("posts").queryOrdered(byChild: "date").queryEqual(toValue: userName, childKey: "author").observe(.childAdded, with: { (snapshot) -> Void in
            
            let values = snapshot.value as? NSDictionary
            
            let post = Post.init(userId: values?["uid"] as? String ?? "",
                                 author: values?["author"] as? String ?? "",
                                 date: values?["date"] as? String ?? "",
                                 text: values?["text"] as? String ?? "",
                                 imageUrl: values?["imageUrl"] as? String ?? "",
                                 location: values?["location"] as? String ?? "",
                                 likesCount: values?["likesCount"] as? Int ?? 0,
                                 isLikeClicked: values?["imageUrl"] as? Bool ?? false)
            
            posts.append(post)
            
        })
        
        return posts
    }
    
    func getPosts() -> [Post] {
        
        var posts = [Post]()
        
        ref?.child("posts").queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) -> Void in
            
            let values = snapshot.value as? NSDictionary
            
            let post = Post.init(userId: values?["uid"] as? String ?? "",
                                 author: values?["author"] as? String ?? "",
                                 date: values?["date"] as? String ?? "",
                                 text: values?["text"] as? String ?? "",
                                 imageUrl: values?["imageUrl"] as? String ?? "",
                                 location: values?["location"] as? String ?? "",
                                 likesCount: values?["likesCount"] as? Int ?? 0,
                                 isLikeClicked: values?["imageUrl"] as? Bool ?? false)
            
            posts.append(post)
            
        })
        
      return posts
        
    }
    

}
