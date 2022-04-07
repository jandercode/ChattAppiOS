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
    
    func saveContact(username: String) {
        
        let newContact = Contact(user_name: username, e_mail: "test@test.com")
        
        do {
            _ = try db.collection(USERS_COLLECTION).document(newContact.id).setData(from: newContact)
        } catch {
            print("error saving to db")
        }
    }
    
    func deleteContact(at indexSet: IndexSet) {
        for index in indexSet {
            let contact = contacts[index]
                db.collection(USERS_COLLECTION).document(contact.id).delete()
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
