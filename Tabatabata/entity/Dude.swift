//
//  User.swift
//  Tabatabata
//
//  Created by Jordane HUY on 22/03/2018.
//  Copyright © 2018 Jordane HUY. All rights reserved.
//

import Foundation
import RealmSwift

class Dude : Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var picture = ""
    @objc dynamic var lastname = ""
    @objc dynamic var firstname = ""
    @objc dynamic var gender = 0
    @objc dynamic var tsCreation = Date()
    @objc dynamic var delete = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
