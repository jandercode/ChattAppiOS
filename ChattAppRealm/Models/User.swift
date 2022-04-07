//
//  User.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-06.
//

import Foundation

struct User {
    var id : String = UUID().uuidString
    var name : String
    var lastName : String
    var username : String
    var email : String
    var password : String
    
}

