//
//  Model.swift
//  chopchop
//
//  Created by Maor Eini on 18/03/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation
import UIKit

let notifyUserListUpdate = "com.maoreini.chopchop.NotifyUserListUpdate"
let notifyFeedItemListUpdate = "com.maoreini.chopchop.NotifyFeedItemListUpdate"

extension Date {
    
    func toFirebase()->Double{
        return self.timeIntervalSince1970 * 1000
    }
    
    static func fromFirebase(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    
    static func fromFirebase(_ interval:Double)->Date{
        if (interval>9999999999){
            return Date(timeIntervalSince1970: interval/1000)
        }else{
            return Date(timeIntervalSince1970: interval)
        }
    }
    
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
}


class Model{
    static let instance = Model()
    
    var currentUser : User? = nil
    
    lazy private var modelSql:ModelSql? = ModelSql()
    lazy private var modelFirebase:ModelFirebase? = ModelFirebase()
    
    private init(){
    }
    
    func registerUser(name: String, email: String, password: String, complition: @escaping (Bool) -> ()) {
        
        modelFirebase?.registerUser(name: name, email: email, password: password) {
            result in
            if(result != nil) {
                self.addUser(u: result!)
                complition(true)
            }
            complition(false)
     
        }
    }
    
    func signInUser(name: String, email: String, password: String, completion: @escaping (Bool) -> ()) {
        modelFirebase?.signInUser(name: "", email: email, password: password) { result in
            if (result != nil) {
                
                self.currentUser = result
                
                completion(true)
            }
            completion(false)
        }
    }
    
    func addUser(u:User){
        modelFirebase?.addUser(u: u){(error) in
            //u.addUserToLocalDb(database: self.modelSql?.database)
        }
    }
    
    func getUserById(id:String, callback:@escaping (User)->Void){
    }
    
    func getAllUsers(callback:@escaping ([User])->Void){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTableService.getLastUpdateDate(database: modelSql?.database, table: User.USER_TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllUsers(lastUpdateDate, callback: { (users) in
            //update the local db
            print("got \(users.count) new records from FB")
            var lastUpdate:Date?
            for u in users{
                u.addUserToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = u.lastUpdate
                }else{
                    if lastUpdate!.compare(u.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = u.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTableService.setLastUpdate(database: self.modelSql!.database, table: User.USER_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = User.getAllUsersFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the caller
            callback(totalList)
        })
    }
    
    func getAllUsersAndObserve(){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTableService.getLastUpdateDate(database: modelSql?.database, table: User.USER_TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllUsersAndObserve(lastUpdateDate, callback: { (users) in
            //update the local db
            print("got \(users.count) new records from FB")
            var lastUpdate:Date?
            for u in users{
                u.addUserToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = u.lastUpdate
                }else{
                    if lastUpdate!.compare(u.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = u.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTableService.setLastUpdate(database: self.modelSql!.database, table: User.USER_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = User.getAllUsersFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the observers using notification center
            NotificationCenter.default.post(name: Notification.Name(rawValue:
                notifyFeedItemListUpdate), object:nil , userInfo:["feedItems":totalList])
        })
    }
    
    func addFeedItem(fi:FeedItem){
        modelFirebase?.addFeedItem(fi: fi){(error) in
            //u.addFeedItemToLocalDb(database: self.modelSql?.database)
        }
    }
    
    func getFeedItemById(id:String, callback:@escaping (FeedItem)->Void){
    }
    
    func getAllFeedItems(callback:@escaping ([FeedItem])->Void){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTableService.getLastUpdateDate(database: modelSql?.database, table: FeedItem.FEED_TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllFeedItems(lastUpdateDate, callback: { (feedItems) in
            //update the local db
            var lastUpdate:Date?
            for fi in feedItems{
                fi.addFeedItemToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = fi.lastUpdate
                }else{
                    if lastUpdate!.compare(fi.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = fi.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTableService.setLastUpdate(database: self.modelSql!.database, table: FeedItem.FEED_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = FeedItem.getAllFeedItemsFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the caller
            callback(totalList)
        })
    }
    
    func getAllFeedItemsAndObserve(){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTableService.getLastUpdateDate(database: modelSql?.database, table: FeedItem.FEED_TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllFeedItemsAndObserve(lastUpdateDate, callback: { (feedItems) in
            //update the local db
            var lastUpdate:Date?
            for fi in feedItems{
                fi.addFeedItemToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = fi.lastUpdate
                }else{
                    if lastUpdate!.compare(fi.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = fi.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTableService.setLastUpdate(database: self.modelSql!.database, table: FeedItem.FEED_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = FeedItem.getAllFeedItemsFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the observers using notification center
            NotificationCenter.default.post(name: Notification.Name(rawValue:
                notifyFeedItemListUpdate), object:nil , userInfo:["feedItems":totalList])
        })
    }

    
    func saveImage(image:UIImage, callback:@escaping (String?)->Void){
        let imageName = UUID().uuidString + ".jpg"
        
        //1. save image to Firebase
        modelFirebase?.saveImageToFirebase(image: image, name: imageName, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: imageName)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
        }else{
            //2. get the image from Firebase
            modelFirebase?.getImageFromFirebase(url: urlStr, callback: { (image) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
            })
        }
    }
    
    
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    
    
}

