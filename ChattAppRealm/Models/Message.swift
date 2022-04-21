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
   // var receiver : String = ""
    @Persisted var text : String
    @Persisted var timestamp : Date? = nil // NSDate().timeIntervalSince1970
    @Persisted(primaryKey: true) var id : String = UUID().uuidString
  //  var date = Date().timeIntervalSinceReferenceDate
}
