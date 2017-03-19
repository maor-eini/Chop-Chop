//
//  User+sql.swift
//  chopchop
//
//  Created by Maor Eini on 18/03/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import Foundation


extension User{
    static let USER_TABLE = "USERS"
    static let USER_ID = "USER_ID"
    static let USER_NAME = "NAME"
    static let USER_EMAIL = "EMAIL"
    static let USER_LAST_UPDATE = "USER_LAST_UPDATE"
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + USER_TABLE + " ( " + USER_ID + " TEXT PRIMARY KEY, "
            + USER_NAME + " TEXT, "
            + USER_EMAIL + " TEXT, "
            + USER_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addUserToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + User.USER_TABLE
            + "(" + User.USER_ID + ","
            + User.USER_NAME + ","
            + User.USER_EMAIL + ","
            + User.USER_LAST_UPDATE + ") VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = self.id.cString(using: .utf8)
            let name = self.name.cString(using: .utf8)
            let email = self.email.cString(using: .utf8)

            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, email,-1,nil);
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 4, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllUsersFromLocalDb(database:OpaquePointer?)->[User]{
        var Users = [User]()
        var sqlite3_stmt: OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(database,"SELECT * from USERS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                let id =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let name =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let email =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))

                let user = User(id: id!,name: name!, email: email!)
                Users.append(user)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return Users
    }
    
}
