//
//  Validators.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-22.
//

import Foundation

class Validators{
    //takes in a String and checks if it has a valid e-mail pattern
    static func textFieldValidatorEmail(_ string: String) -> Bool {
        
        if string.count > 100 {
            return false
            
        }
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // short format
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
        
    }
    // takes in a string and checks if it corresponds to every password limitation 
    static func textFieldValidatorPassword(_ password: String, _ repeatePassword: String) -> Bool{
        
        if password == "" || password.contains(" ") || password != repeatePassword || password.count < 5{
            
            return false
            
        }else{
            
            return true
        }
    }
    
    static func checkForSameUsername(newUsername: String, registeredUsers: [User]) -> Bool{
        
        if !registeredUsers.isEmpty{
            
            for user in registeredUsers{
                print(user.username)
                if user.username == newUsername{
                    
                    return true
                    
                }else{
                    
                    return false
                }
            }
        }
        return false
    }
    
    
    static func checkForSameEmail(newEmail: String, registeredUsers: [User]) -> Bool{
        
        if !registeredUsers.isEmpty{
            
            for user in registeredUsers{
                print(user.email)
                if user.email == newEmail{
                    
                    return true
                    
                }else{
                    
                    return false
                }
            }
        }
        
        return false
        
    }
    
    
}


