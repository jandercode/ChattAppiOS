//
//  Contact.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation

struct Contact : Codable {
    var id : String = UUID().uuidString
    var name : String
    var lastName : String
    var username : String
    var email : String    
}
