//
//  Chat.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-08.
//

import Foundation

struct Chat : Codable, Identifiable {
    var id : String = UUID().uuidString
    var users_in_chat : [String] = [String]()
    var chat_name = ""
    var lastMessage: String = ""
}
