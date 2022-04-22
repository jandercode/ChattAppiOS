//
//  RegisterView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-22.
//

import SwiftUI

struct RegisterView: View{
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var eMail: String
    @Binding var password: String
    var userDao: UserDao
    
    @State var firstName = ""
    @State var lastName = ""
    @State var userName = ""
    @State var repeatPassword = ""
    
    @State var showSuccessAlert = false
    @State var showFailureAlert = false
    @State var showSameMailAlert = false
    
    @ObservedObject var firestore = FirestoreContactDao.firestoreContactDao
    
    @State private var error: ErrorInfo?

    
    var body: some View{
        
        VStack{
            
            TextField("username", text: $userName)
                .autocapitalization(.none)
            
            TextField("mail", text: $eMail)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            HStack{
                
                TextField("first name", text: $firstName)
                
                TextField("last name", text: $lastName)
                
            }
            
            SecureInputView("password", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureInputView("repeat password", text: $repeatPassword)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    
                    if Validators.checkForSameEmail(newEmail: eMail, registeredUsers: firestore.registeredUsers){
                        
                        error = ErrorInfo(id: 3, title: "Error", description: "An account with the same e-mail adress already exists")
                        
                    }else{
                        
                        if Validators.checkForSameUsername(newUsername: userName, registeredUsers: firestore.registeredUsers){
                            
                            error = ErrorInfo(id: 4, title: "Error", description: "An account with the same username already exists")
                            
                        }else{
                            
                            if Validators.textFieldValidatorPassword(password, repeatPassword) && Validators.textFieldValidatorEmail(eMail)
                                && !userName.isEmpty && !eMail.isEmpty && !firstName.isEmpty{
                                
                                let user = User()
                                user.username = userName
                                user.email = eMail
                                user.firstName = firstName
                                user.lastName = lastName
                                user.password = password

                                userDao.saveUser(newUser: user)
                                FirestoreContactDao.firestoreContactDao.saveNewUser(user: user)

                                error = ErrorInfo(id: 1, title: "Account Created", description: "Your account has been created successfully \(userName)")
                                
                            }else{
                                
                                error = ErrorInfo(id: 2, title: "Error", description: "something went wrong, check again!")
                            }
                        }
                    }

                }, label: {
                    Text("Register")
                    
                }).alert(item: $error, content: { error in
                    
                    Alert(
                        
                        title: Text(error.title),
                        message: Text(error.description)
                    )
                })
                .padding()
                
                Spacer()
                
                Button(action: {
                    
                    dismiss()
                    
                }, label: {
                    Text("Return")
                })
                
                Spacer()
                
            }
            .buttonStyle(.bordered)
            .padding(.top)
            
        }
        .textFieldStyle(.roundedBorder)
        .padding(.leading)
        .padding(.trailing)
        
    }
}
