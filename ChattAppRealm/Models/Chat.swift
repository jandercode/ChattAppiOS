//
//  Chat.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-08.
//

import Foundation

struct Chat : Codable, Identifiable {
    var id : String = UUID().uuidString
    var usersInChat : [String] = [String]()
}
