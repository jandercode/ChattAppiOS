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
    var timestamp : Date = Date() // NSDate().timeIntervalSince1970
    @Persisted var id : String = UUID().uuidString
  //  var date = Date().timeIntervalSinceReferenceDate
}
