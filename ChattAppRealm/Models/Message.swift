//
//  Message.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation
import RealmSwift

class Message : Object, Codable, Identifiable {
    
    @Persisted var sender : String
    @Persisted var text : String
    @Persisted var timestamp : Date? = nil
    @Persisted (primaryKey: true) var id : String = UUID().uuidString
    @Persisted var referenceChatId : String = ""

}
