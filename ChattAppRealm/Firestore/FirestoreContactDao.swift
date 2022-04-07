//
//  FirestoreContactDao.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreContactDao {
    
    let db = Firestore.firestore()
    
    private let ID_KEY = "id"
    private let USERNAME_KEY = "username"
    private let EMAIL_KEY = "email"
    private let USERS_COLLECTION = "contacts"
    
    func saveContact() {
        
        let newContact = Contact(name: "test_name", lastName: "test_last_name", username: "test_username", email: "test_email")
        
        do {
            _ = try db.collection(USERS_COLLECTION)
                .addDocument(from: newContact)
        } catch {
            print("error saving to db")
        }
        
        
    }
}
