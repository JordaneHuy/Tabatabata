//
//  DudeDAO.swift
//  Tabatabata
//
//  Created by Jordane HUY on 27/03/2018.
//  Copyright © 2018 Jordane HUY. All rights reserved.
//

import Foundation
import RealmSwift

class DudeDAO {
    let realm = try! Realm()
    
    func getDudes() -> Array<Dude> {
        // Query Realm for all Dudes
        let dudes = Array(realm.objects(Dude.self))
        
        return dudes
    }
    
    func deleteAllDudes() {
        let dudes = Array(realm.objects(Dude.self))

        // Query Realm delete all Dudes
        try! realm.write {
            realm.delete(dudes)
        }
    }
    
    func deleteDude(dude:Dude) {
        // Query Realm delete all Dudes
        try! realm.write {
            realm.delete(dude)
        }
    }
    
    func createDude(dude:Dude) {
        // Query Realm create Dude
        try! realm.write {
            realm.add(dude)
        }
    }
    
    func updateDude(dude: Dude) {
        // Query Realm update Dude
        try! realm.write {
            realm.add(dude, update: true)
        }
    }
}
