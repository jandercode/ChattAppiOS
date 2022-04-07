//
//  FirestoreContactDao.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class FirestoreContactDao : ObservableObject {
    
    let db = Firestore.firestore()
    @Published var contacts = [Contact]()
    
    private let ID_KEY = "id"
    private let USERNAME_KEY = "username"
    private let EMAIL_KEY = "email"
    private let USERS_COLLECTION = "contacts"
    
    func saveContact() {
        
       // let newContact = Contact(name: "test_name", lastName: "test_last_name", username: "test_username", email: "test_email")
        let newContact = Contact(e_mail: "test@test.com", user_name: "Teddy")
        
        do {
            _ = try db.collection(USERS_COLLECTION)
                .addDocument(from: newContact)
        } catch {
            print("error saving to db")
        }
        
        
    }
    
    func listenToFirestore() {
        db.collection(USERS_COLLECTION).addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.contacts.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Contact.self)
                    }
                    switch result {
                    case .success(let contact) :
                        self.contacts.append(contact)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
}
