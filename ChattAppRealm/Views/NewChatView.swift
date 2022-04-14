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
    @State var usersInChat : [String] = [UserManager.userManager.currentUser?.id ?? User().id]
    
    @State private var searchTerm: String = ""
    @State private var selection = Set<User>()
    @State private var isEditMode: EditMode = .active
    @State private var label = "Add Contact"
    @State var chatName : String = ""
    
    var body: some View {
            
            VStack {
                
                HStack {
                    Text("To:")
                    TextField("Type a name or group", text: $searchTerm)
                        .autocapitalization(.none)

                }
                    
                    List(searchResult(), id: \.self, selection: $selection){ user in
                            
                            Text(user.username)

                    }
                    .searchable(text: $searchTerm)
                }
                .environment(\.editMode, self.$isEditMode)
                
            Spacer()
                
                HStack{
                    
                    Button {
                    
                        for user in selection{
                            
                            usersInChat.append(user.id)
                        }
                        
                        removeDoubles()
                        
                        if !checkIfChatExists(){
                            
                            showChatView = true
                            
                        }else{
                            
                            print("exists!!")
                        }
                        chatName = FirestoreChatDao.firestoreChatDao.createChatName(usersInChat: usersInChat)
                        
                    } label: {
                        Text("Start Chatting!!")
                    }
                }
        NavigationLink(destination: MessagesView(chatId: "", usersInChat: usersInChat,chatName: FirestoreChatDao.firestoreChatDao.removeCurrentFromChatName(chatName: chatName)), isActive: $showChatView) {
                    EmptyView()
                }.isDetailLink(false)
                
            }
    
    
    func removeDoubles(){
        
        var index = -1
        
        for item in usersInChat{
            
            var counter = 0
            
            for item2 in usersInChat{
                
                if item == item2{
                    counter += 1
                    if counter > 1{
                        index = usersInChat.firstIndex(of: item2)!
                    }
                }
            }
            if index > -1{
                usersInChat.remove(at: index)
                index = -1
            }
        }
        
    }
    
    
    func checkIfChatExists() -> Bool{
        
        for chat in FirestoreChatDao.firestoreChatDao.chats{
            
            if chat.users_in_chat.count == usersInChat.count{
                
                if chat.users_in_chat.sorted() == usersInChat.sorted(){
                    
                    return true
                }
                
            }
            
        }
        
        return false
       
    }
    
    func searchResult() -> [User]{
        
        var result = [User]()
        
        if searchTerm.isEmpty{
            
            result.append(contentsOf: FirestoreContactDao.firestoreContactDao.registeredUsers)
        
        }else{
            
            for user in FirestoreContactDao.firestoreContactDao.registeredUsers{
                                
                if user.username.contains(searchTerm){
                    
                    result.append(user)
                    
                }
            }
        }
        
        return result
        
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}

