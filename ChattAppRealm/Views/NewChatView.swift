//
//  NewChatView.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//

import SwiftUI
import Firebase

struct NewChatView: View {
    @State private var showChatView = false
    @State var usersInChat : [String] = [UserManager.userManager.currentUser?.username ?? User().username]
    
    @State private var searchTerm: String = ""
    @State private var selection = Set<User>()
    @State private var isEditMode: EditMode = .inactive
    @State private var label = "Add Contact"
    
    var body: some View {
            
            VStack {
                
                HStack {
                    Text("To:")
                    TextField("Type a name or group", text: $searchTerm)

                }
                NavigationView{
                    
                    List(FirestoreContactDao.firestoreContactDao.registeredUsers, id: \.self, selection: $selection){ user in
                            
                            Text(user.username)

                    }
                    .toolbar {
                        Button {
                            
                            if isEditMode == .active{
                                label = "Add Contact"
                                isEditMode = .inactive
                            }else{
                                label = "Done"
                                isEditMode = .active
                            }
                            
                        } label: {
                            Text(label)
                        }

                    }
                }
                .environment(\.editMode, self.$isEditMode)
                
            Spacer()
                
                HStack{
                    
                    Button {
                        
                        for user in selection{
                            
                            usersInChat.append(user.username)
                            
                        }
                        
                        showChatView = true
                        
                    } label: {
                        Text("Start Chatting!!")
                    }

                    
                }
                NavigationLink(destination: MessagesView(chatId: "", usersInChat: usersInChat), isActive: $showChatView) {
                    EmptyView()
                }.isDetailLink(false)
                
            }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}

