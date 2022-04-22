//
//  UserManager.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-21.
//

import Foundation
import SwiftUI

//SINGLETON
class UserManager: ObservableObject{
    
    static let userManager = UserManager()
    var currentUser: User? = nil
    var userImage: UIImage? = nil
    @Published var imageArray : [String:UIImage] = [:]
    
    private init(){
        loadStandardProfilePicture()
    }
    
    func loadStandardProfilePicture(){
        
        for user in FirestoreContactDao.firestoreContactDao.registeredUsers{
            
            imageArray[user.id] = UIImage(systemName: "person.circle")
            
        }
        
    }
    
    
    
}
