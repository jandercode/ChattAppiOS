//
//  Contact.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation

struct Contact : Codable, Identifiable {
    var id : String = UUID().uuidString
    var user_name : String
    var e_mail : String
}
