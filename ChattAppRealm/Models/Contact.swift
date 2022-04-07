//
//  Contact.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation

struct Contact : Codable, Identifiable {
//    var id : String = UUID().uuidString
//    var name : String
//    var lastName : String
//    var username : String
//    var email : String
    
    // temporary fields to get it to work with existing documents from android version:
    var e_mail : String
    var id : String = UUID().uuidString
    var user_name : String
}
