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
    
    func getUser(uid: String, completion: @escaping (User) ->()) {
        
        var users = [User]()
        
        ref?.child("users").queryEqual(toValue: uid, childKey: "uid").observe(.childAdded, with: { (snapshot) -> Void in
            
            let values = snapshot.value as? NSDictionary
            
            let user = User.init(userId: values?["uid"] as? String ?? "",
                                 name: values?["name"] as? String ?? "",
                                 email: values?["email"] as? String ?? "")
            
            users.append(user)
            completion(user)
        })
    }
    
    func addFeedItem(feedItem: FeedItem, withCompletionBlock completion: @escaping (Bool) -> ()){
        
        let key = ref?.child("feedItems").childByAutoId().key
        
        let newFeedItem = ["uid": feedItem.userId,
                    "author": feedItem.author,
                    "date": feedItem.date,
                    "imageUrl": feedItem.imageUrl,
                    "location": feedItem.location,
                    "likesCount": feedItem.likesCount,
                    "isLikeClicked": feedItem.isLikeClicked] as [String : Any]
        
        ref?.child("feedItems").child(key!).updateChildValues(newFeedItem)  { (err, ref) in
            
            if err != nil {
                print(err as Any)
                completion(false)
                return
            }
            completion(true)
            print("Item Saved")
        }
        
    }
    
    func getFeedItemsByUserName(userName: String) -> [FeedItem] {
        
        var feedItems = [FeedItem]()
        
        ref?.child("feedItems").queryOrdered(byChild: "date").queryEqual(toValue: userName, childKey: "author").observe(.childAdded, with: { (snapshot) -> Void in
            
            let values = snapshot.value as? NSDictionary
            
            let feedItem = FeedItem.init(userId: values?["uid"] as? String ?? "",
                                 author: values?["author"] as? String ?? "",
                                 date: values?["date"] as? String ?? "",
                                 imageUrl: values?["imageUrl"] as? String ?? "",
                                 location: values?["location"] as? String ?? "",
                                 likesCount: values?["likesCount"] as? Int ?? 0,
                                 isLikeClicked: values?["imageUrl"] as? Bool ?? false)
            
            feedItems.append(feedItem)
            
        })
        
        return feedItems
    }
    
    func getFeedItems() -> [FeedItem] {
        
        var feedItems = [FeedItem]()
        
        ref?.child("feedItems").queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) -> Void in
            
            let values = snapshot.value as? NSDictionary
            
            let feedItem = FeedItem.init(userId: values?["uid"] as? String ?? "",
                                 author: values?["author"] as? String ?? "",
                                 date: values?["date"] as? String ?? "",
                                 imageUrl: values?["imageUrl"] as? String ?? "",
                                 location: values?["location"] as? String ?? "",
                                 likesCount: values?["likesCount"] as? Int ?? 0,
                                 isLikeClicked: values?["imageUrl"] as? Bool ?? false)
            
            feedItems.append(feedItem)
            
        })
        
      return feedItems
        
    }
    
    public func uploadToFirebaseStorageUsingImage(_ image: UIImage,feed: FeedItem, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString + ".jpg"
        let ref = FIRStorage.storage().reference().child("images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image")
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    feed.imageUrl = imageUrl
                    ChopchopDataService.sharedInstance.addFeedItem(feedItem: feed, withCompletionBlock: {(result) in })
                }
            })
        }
    }
    

}
