//
//  ModelSql.swift
//  chopchop
//
//  Created by Maor Eini on 18/03/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation

extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,
                                                  repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}


class ModelSql{
    var database: OpaquePointer? = nil
    
    init?(){
        let dbFileName = "database.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return nil
            }
        }
        
        if User.createTable(database: database) == false{
            return nil
        }
        
        if FeedItem.createTable(database: database) == false{
            return nil
        }
        
        if LastUpdateTableService.createTable(database: database) == false{
            return nil
        }
    }
}
