//
//  UserInfoView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-11.
//

import SwiftUI

struct UserInfoView: View {
    
    var storage: StorageManager
    @State var imageChanged: Bool
    
    @Environment(\.dismiss) var dismiss
    let userName = UserManager.userManager.currentUser!.username
    @State var eMail = UserManager.userManager.currentUser!.email
        
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var userImage: UIImage = UIImage(systemName: "person.circle")!
    @State private var logOut: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .center){
            
            VStack{
                Button {
                   
                    showPhotoPicker = true
                    
                } label: {
                    ProfilePic(size: 46, image: userImage)
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
                                    imageChanged = true
                                }
                            }
                        }
                    }
                        .edgesIgnoringSafeArea(.all)
                }
                
                HStack{
                    
                    Spacer()
                    
                    Text(userName)
                        .padding()
                    
                    Spacer()
                    
                }
                .padding()
                
                
                
                HStack{
                    
                    Text("Name: \(UserManager.userManager.currentUser!.firstName)")
                        .padding()
                    Text("Surname: \(UserManager.userManager.currentUser!.lastName)")
                        .padding()
                    
                }
                .padding()
                
                HStack{
                    
                    Spacer()
                    
                    Text("Email:")
                    TextField("Email", text: $eMail)
                        .textFieldStyle(.roundedBorder)
                    
                    Spacer()
                }
                .padding()
                
                HStack{
                    
                    Button {
                        updateUser()
                    } label: {
                        Text("Save Changes")
                    }
                    .padding()
                    
                    Button {
                        logUserOut()
                        dismiss()
                    } label: {
                        Text("Logout")
                    }
                    .padding()
                    
                }
            }
        }
        .onAppear{
            
            if UserManager.userManager.userImage != nil{
                userImage = UserManager.userManager.userImage!
            }
        }
        
    }
    
    func logUserOut(){
        
//        let userDao = UserDao()
//        userDao.eraseUserData()
        manageLoginInfo.saveLogin(saveInfo: false)
        UserData.loggedOut = true
        
    }
    
    func updateUser(){
        
        if eMail != UserManager.userManager.currentUser!.email{
            
            FirestoreContactDao.firestoreContactDao.upadateCurrentUserData(data: eMail, operation: ActionType.email)
        }
        
        dismiss()
    }
    
}


