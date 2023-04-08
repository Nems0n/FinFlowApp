//
//  FFRealmManager.swift
//  FinFlow
//
//  Created by Vlad Todorov on 8.04.23.
//

import RealmSwift

final class FFRealmManager {
    static let shared = FFRealmManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    public func add(_ object: Object) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    public func delete(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
}
