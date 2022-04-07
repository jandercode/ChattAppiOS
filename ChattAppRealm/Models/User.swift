//
//  User.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-06.
//

import Foundation
import RealmSwift

class User: Object {
    
    @Persisted(primaryKey: true) var id : String = UUID().uuidString
    @Persisted var name : String = ""
    @Persisted var lastName : String = "none"
    @Persisted var username : String = ""
    @Persisted var email : String = ""
    @Persisted var password : String = ""
    
}

