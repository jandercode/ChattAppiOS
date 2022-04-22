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
    
    let firestore = FirestoreContactDao.firestoreContactDao
    
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
                            
                            if newPassword == repeatNewPassword{

                                ManageLoginInfo.saveLogin(saveInfo: false)
                                firestore.upadateCurrentUserData(data: newPassword, operation: ActionType.password)
                                print(ManageLoginInfo.loadLogin())
                                dismiss()
                                
                            }else{
                                
                                differentPsw = true
                            }
                            
                        }else{
                            samePsw = true
                        }
                        
                    }else{
                        oldPswWrong = true
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
            
        }.alert("The old and New Password are the same", isPresented: $samePsw) {
            Button("Ok", role: .cancel){}
        }
        .alert("The new and repeat field are different", isPresented: $differentPsw) {
            Button("Ok", role: .cancel){}
        }
        .alert("The current password is wrong", isPresented: $oldPswWrong) {
            Button("Ok", role: .cancel){}
        }
        
        
    }
}
