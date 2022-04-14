//
//  UserInfoView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-11.
//

import SwiftUI

struct UserInfoView: View {
    
    var storage: StorageManager
    
    @Environment(\.dismiss) var dismiss
    @State var userName = UserManager.userManager.currentUser!.username
    @State var eMail = UserManager.userManager.currentUser!.email
        
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var userImage: UIImage = UIImage(systemName: "person.circle")!
    
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
                                }
                            }
                        }
                    }
                        .edgesIgnoringSafeArea(.all)
                }
                
                HStack{
                    
                    Spacer()
                    
                    Text("Username:")
                    TextField("UserName", text: $userName)
                        .textFieldStyle(.roundedBorder)
                    
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

                    
                }
            }
        }.onAppear{
            
            if UserManager.userManager.userImage != nil{
                userImage = UserManager.userManager.userImage!
            }
        }
    }
    
    func updateUser(){
        
        if eMail != UserManager.userManager.currentUser!.email{
            
            FirestoreContactDao.firestoreContactDao.upadateCurrentUserData(data: eMail, operation: ActionType.email)
        }
        
        if userName != UserManager.userManager.currentUser?.username{
            
            FirestoreContactDao.firestoreContactDao.upadateCurrentUserData(data: userName, operation: ActionType.userName)
            
        }
        
        
        dismiss()
    }
    
}


