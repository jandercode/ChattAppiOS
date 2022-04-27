//
//  ChangePasswordSheet.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-22.
//

import SwiftUI

struct changePasswordSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var repeatNewPassword: String = ""
    
    @State private var samePsw: Bool = false
    @State private var differentPsw: Bool = false
    @State private var oldPswWrong: Bool = false
    @State private var shortPsw: Bool = false
    
    @State private var error: ErrorInfo?
    
    let firestore = FirestoreUserDao.firestoreContactDao
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                SecureInputView("Old Password", text: $oldPassword)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            HStack{
                
                SecureInputView("New Password", text: $newPassword)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
            }
            
            HStack{
                
                SecureInputView("Repeat New Password", text: $repeatNewPassword)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
            }
            
            HStack{
                
                Button {
                    
                    if UserManager.userManager.currentUser?.password == oldPassword{
                        
                        if oldPassword != newPassword{
                            
                            if Validators.textFieldValidatorPassword(newPassword, repeatNewPassword){
                                
                                ManageLoginInfo.saveLogin(saveInfo: false)
                                firestore.upadateCurrentUserData(data: newPassword, operation: ActionType.password)
                                print(ManageLoginInfo.loadLogin())
                                dismiss()
                                
                            }else{
                                
                                error = ErrorInfo(id: 3, title: "Error", description: "The new password is too short or are different then the repeat")
                            }
                            
                        }else{
                            
                            error = ErrorInfo(id: 2, title: "Error", description: "The old and new password are the same")
                        }
                        
                    }else{
                        
                        error = ErrorInfo(id: 1, title: "Error", description: "The old password is wrong")
                    }
                    
                } label: {
                    
                    Text("Save")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button {
                    
                    print("canceled")
                    dismiss()
                    
                } label: {
                    
                    Text("Return")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            
        }.alert(item: $error, content: { error in
            
            Alert(
                
                title: Text(error.title),
                message: Text(error.description)
            )
        })
            .padding()
        
    }
}
