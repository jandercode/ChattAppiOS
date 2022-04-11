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
    
    static let firestoreContactDao = FirestoreContactDao()
    
    private init(){}
    
    let db = Firestore.firestore()
    @Published var contacts = [Contact]()
    var registeredUsers = [User]()
    
    private let ID_KEY = "id"
    private let USERNAME_KEY = "username"
    private let EMAIL_KEY = "email"
    private let CONTACT_COLLECTION = "contacts"
    
    private let USERS_COLLECTION = "users"
    private let FIRST_NAME_KEY = "first_name"
    private let LAST_NAME_KEY = "last_name"
    private let PASSWORD_KEY = "password"
    
    
    
    func saveContact(username: String) {
        
        let newContact = Contact(user_name: username, e_mail: "test@test.com")
        
        do {
            _ = try db.collection(CONTACT_COLLECTION).document(newContact.id).setData(from: newContact)
        } catch {
            print("error saving to db")
        }
    }
    
    func deleteContact(at indexSet: IndexSet) {
        for index in indexSet {
            let contact = contacts[index]
                db.collection(CONTACT_COLLECTION).document(contact.id).delete()
        }
    }

    func listenToFirestore() {
        
        db.collection(CONTACT_COLLECTION).addSnapshotListener { snapshot, err in
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
    
    func checkForSameEmail(email: String) -> Bool{
        
        if !registeredUsers.isEmpty{
            
            for user in registeredUsers{
                
                if user.email == email{
                    
                    return true
                    
                }else{
                    
                    return false
                }
            }
        }
            
            return false
        
    }
    
    func saveNewUser(user: User){
        
        let newUser : [String : String] = [
            ID_KEY : user.id,
            USERNAME_KEY : user.username,
            FIRST_NAME_KEY : user.firstName,
            LAST_NAME_KEY : user.lastName,
            EMAIL_KEY : user.email,
            PASSWORD_KEY : user.password]
        
        do{
            
            _ = try db.collection(USERS_COLLECTION).document(user.id).setData(from: newUser)
            print("success")
            
        }catch{
            
            print("error saving to DB")
        }
    }
    
    
    func checkLogin(mail: String, password: String){
        
        db.collection(USERS_COLLECTION).whereField(EMAIL_KEY, isEqualTo: mail)
            .getDocuments(){(querysnapshot, err) in
                if let err = err {
                    
                    print(err)
                    
                }else{
                    
                    var data : [String : Any]
                    
                    for doc in querysnapshot!.documents{
                        
                        data = doc.data()
                        
                        if data[self.PASSWORD_KEY] as! String == password{
                            
                            self.setCurrentUsert(data: data)
                    }
                        print("success")
                        
                    }
                }
            }
    }
    
    func setCurrentUsert(data: [String:Any]){
        
        let user = User()
        user.username = data[self.USERNAME_KEY] as! String
        user.id = data[self.ID_KEY] as! String
        user.firstName = data[self.FIRST_NAME_KEY] as! String
        user.lastName = data[self.LAST_NAME_KEY] as! String
        user.email = data[self.EMAIL_KEY] as! String
        user.password = data[self.PASSWORD_KEY] as! String
        UserManager.userManager.currentUser = user
        
    }
    
    func getUsers(){
        
        db.collection(USERS_COLLECTION).getDocuments(){ querySnapshot, err in
            
            if let e = err{
                print("ERROR \(e)")
            }else{
                self.registeredUsers.removeAll()
                for doc in querySnapshot!.documents{
                    
                    let data = doc.data()
                    let user = User()
                    user.id = data[self.ID_KEY] as! String
                    user.username = data[self.USERNAME_KEY] as! String
                    user.email = data[self.EMAIL_KEY] as! String
                    
                    self.registeredUsers.append(user)
                    
                }
            }
        }
    }
    
    func eraseUsers(){
        
        registeredUsers.removeAll()
        
    }
    
    
    
}
