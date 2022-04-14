//
//  UserInfoView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-11.
//

import SwiftUI

struct UserInfoView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var userName = UserManager.userManager.currentUser!.username
    @State var eMail = UserManager.userManager.currentUser!.email
    
    let storage = StorageManager()
    
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var userImage = "person.circle"
    
    var body: some View {
        
        ZStack(alignment: .center){
            
            VStack{
                Button {
                   
                    showPhotoPicker = true
                    
                } label: {
                    Image(systemName: userImage)
                        .resizable()
                        .frame(width: 46.0, height: 46.0)
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
                                    storage.upload(image: selectedImage!, name: UserManager.userManager.currentUser!.username)
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

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
