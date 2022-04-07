//
//  Message.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation

struct Message : Codable, Identifiable {
    var id : String = UUID().uuidString
    var sender : String = "dave"
    var receiver : String = ""
    var text : String = ""
    var timestamp : Date = Date()
}
