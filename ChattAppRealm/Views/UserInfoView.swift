//
//  UserInfoView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-11.
//

import SwiftUI

struct UserInfoView: View {
    
    var storage: StorageManager
    @ObservedObject var state: StateController
    @Binding var userImage : UIImage?
    
    @Environment(\.dismiss) var dismiss
    let username = UserManager.userManager.currentUser!.username
    @State var email = UserManager.userManager.currentUser!.email
    
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var changePassword: Bool = false
    
    let firstName = UserManager.userManager.currentUser?.firstName
    let lastName = UserManager.userManager.currentUser?.lastName
    
    var body: some View {
        
        ZStack(alignment: .center){
            
            VStack{
                Button {
                    
                    showPhotoPicker = true
                    
                } label: {
                    Image(uiImage: userImage!)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(50/2)
                }
                .fullScreenCover(isPresented: $showPhotoPicker) {
                    PhotoPicker(filter: .images, limit: 1){results in
                        PhotoPicker.convertToUIImageArray(fromResults: results){ imagesOrNil, errorOrNil in
                            if let error = errorOrNil{
                                print(error)
                            }
                            if let images = imagesOrNil{
                                if let first = images.first{
                                    selectedImage = first
                                    UserManager.userManager.userImage = selectedImage
                                    userImage = selectedImage!
                                    storage.upload(image: selectedImage!, id: UserManager.userManager.currentUser!.id)
                                    
                                }
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                
                HStack{
                    
                    Spacer()
                    
                    Text(username)
                        .padding()
                    
                    Spacer()
                    
                }
                .padding()
                
                HStack{
                    
                    Text("Name: " + (firstName ?? "name"))
                        .padding()
                    Text("Surname: " + (lastName ?? "lastName"))
                        .padding()
                    
                }
                .padding()
                
                HStack{
                    
                    Spacer()
                    
                    Text("Email:")
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                    
                    Spacer()
                    
                }
                .padding()
                
                HStack{
                    
                    Button {
                        changePassword = true
                    } label: {
                        Text("Change Password")
                    }
                    .padding()
                    
                    Button {
                        state.appState = .BackupPage
                    } label: {
                        Text("View Backups")
                            .foregroundColor(.green)
                    }
                }
                
                HStack{
                    
                    Button {
                        updateUser()
                    } label: {
                        Text("Save Changes")
                    }
                    .padding()
                    
                    Button {
                        
                        logUserOut()
                        
                    } label: {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                    .padding()
                    
                }
            }
        }.sheet(isPresented: $changePassword, content: {
            changePasswordSheet()
        })
            .onAppear{
                
                if UserManager.userManager.userImage != nil{
                    userImage = UserManager.userManager.userImage!
                }
            }
    }
    
    func logUserOut(){
        
        ManageLoginInfo.saveLogin(saveInfo: false)
        state.appState = .Login
    }
    
    func updateUser(){
        
        if email != UserManager.userManager.currentUser!.email{
            
            if Validators.textFieldValidatorEmail(email){
                
                FirestoreUserDao.firestoreContactDao.upadateCurrentUserData(data: email, operation: ActionType.email)
                ManageLoginInfo.saveLogin(saveInfo: false)
            }
        }
        
        dismiss()
    }
    
}


