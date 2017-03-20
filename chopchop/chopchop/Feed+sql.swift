//
//  Feed+sql.swift
//  chopchop
//
//  Created by Maor Eini on 18/03/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

//
//  FeedItem+sql.swift
//  chopchop
//
//  Created by Maor Eini on 18/03/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation

//var feedItemId: String
//var userId: String
//var date: String
//var author: String
//var imageUrl: String
//var location: String
//var likesCount: Int
//var isLikeClicked: Bool
//var lastUpdate : Date?


extension FeedItem{
    static let FEED_TABLE = "FEED"
    static let FEED_ID = "ID"
    static let FEED_USER_ID = "USER_ID"
    static let FEED_AUTHOR = "AUTHOR"
    static let FEED_DATE = "DATE"
    static let FEED_IMAGE_URL = "IMAGE_URL"
    static let FEED_LOCATION = "FEED_LOCATION"
    static let FEED_LIKES_COUNT = "LIKES_COUNT"
    static let FEED_IS_LIKE_CLICKED = "IS_LIKE_CLICKED"
    static let FEED_LAST_UPDATE = "FEED_LAST_UPDATE"
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + FEED_TABLE + " ( " + FEED_ID + " TEXT PRIMARY KEY, "
            + FEED_USER_ID + " TEXT, "
            + FEED_AUTHOR + " TEXT, "
            + FEED_DATE + " TEXT, "
            + FEED_IMAGE_URL + " TEXT, "
            + FEED_LOCATION + " TEXT, "
            + FEED_LIKES_COUNT + " TEXT, "
            + FEED_IS_LIKE_CLICKED + " TEXT, "
            + FEED_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addFeedItemToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + FeedItem.FEED_TABLE
            + "(" + FeedItem.FEED_ID + ","
            + FeedItem.FEED_USER_ID + ","
            + FeedItem.FEED_AUTHOR + ","
            + FeedItem.FEED_DATE + ","
            + FeedItem.FEED_IMAGE_URL + ","
            + FeedItem.FEED_LOCATION + ","
            + FeedItem.FEED_LIKES_COUNT + ","
            + FeedItem.FEED_IS_LIKE_CLICKED + ","
            + FeedItem.FEED_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = self.id.cString(using: .utf8)
            let userId = self.userId.cString(using: .utf8)
            let author = self.author.cString(using: .utf8)
            let date = self.date.timeIntervalSince1970
            let imageUrl = self.imageUrl.cString(using: .utf8)
            let location = self.location.cString(using: .utf8)
            let likesCount = Int32(self.likesCount)
            let isLikeClicked = Int32((self.isLikeClicked) ? 1 : 0)
            
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, userId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, author,-1,nil);
            sqlite3_bind_double(sqlite3_stmt, 4, date);
            sqlite3_bind_text(sqlite3_stmt, 5, imageUrl,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, location,-1,nil);
            sqlite3_bind_int(sqlite3_stmt, 7, likesCount);
            sqlite3_bind_int(sqlite3_stmt, 8, isLikeClicked);

            
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 9, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllFeedItemsFromLocalDb(database:OpaquePointer?)->[FeedItem]{
        var FeedItems = [FeedItem]()
        var sqlite3_stmt: OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(database,"SELECT * from FEED;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                
                let id =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let userId =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let author =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let date =  sqlite3_column_double(sqlite3_stmt,4)
                let imageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,5))
                let location =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let likesCount =  Int(sqlite3_column_int(sqlite3_stmt,7))
                let isLikeClicked =  (Int(sqlite3_column_int(sqlite3_stmt,8)) == 1) ? true : false;
                
                let feedItem = FeedItem(id: id!, userId: userId!, author: author!,date: Date(timeIntervalSince1970: date), imageUrl: imageUrl!, location: location!, likesCount: likesCount, isLikeClicked: isLikeClicked)
                FeedItems.append(feedItem)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return FeedItems
    }
    
}

