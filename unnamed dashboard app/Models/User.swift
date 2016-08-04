//
//  User.swift
//  unnamed dashboard app
//
//  Created by Dylan Steck on 7/15/16.
//  Copyright © 2016 Dylan Steck. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var userId = ""
    dynamic var fullName = ""
    dynamic var phoneNumber = ""
}