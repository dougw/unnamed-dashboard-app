//
//  RealmHelper.swift
//  WebDeck
//
//  Created by Dylan Steck on 8/4/16.
//  Copyright © 2016 WebDeck. All rights reserved.
//

import RealmSwift

class RealmHelper {
    static func addUser(user: User) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(user)
        }
        
    }
    static func updateUser(userToBeUpdated: User, newUser: User) {
        let realm = try! Realm()
        try! realm.write() {
            userToBeUpdated.userId = newUser.userId
            userToBeUpdated.fullName = newUser.fullName
            userToBeUpdated.phoneNumber = newUser.phoneNumber
        }
    }
    
 
    
//    static func deleteUser(user: User) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.delete(user)
//        }
//    }
//    
//    
//    static func retrieveUsers() -> Results<User> {
//        let realm = try! Realm()
//        return realm.object(user)
//    }
}
