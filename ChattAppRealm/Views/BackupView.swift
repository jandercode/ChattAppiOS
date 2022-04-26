//
//  BackupView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-26.
//

import SwiftUI

struct BackupView: View {
    
    @ObservedObject var state: StateController
    
    @State var showChat = false
    @State var presentationArray = [Chat]()
    
    var body: some View {
        
        
        VStack{
            
            List{
                    
                    ForEach (presentationArray){ chat in
                        
                        ChatRow(chat: chat, chatName: FirestoreChatDao.firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), profilePic: getProfilePic(chat: chat))
                        
                            .onTapGesture {
                                
                                state.usersInChat = chat.users_in_chat
                                state.chatId = chat.id
                                state.chatName = chat.chat_name
                                state.messageRealm?.filterMessages(chatId: state.chatId)
                                state.appState = .BackupChat
                                
                            }
                    }
                    .padding()
                }
                                
            }.onAppear{
                
                if state.chatRealm == nil{
                    state.chatRealm = RealmChatDao()
                    state.chatRealm?.loadChats()
                }
                if state.messageRealm == nil{
                    state.messageRealm = RealmMessageDao()
                    state.messageRealm?.loadMessages()
                }
                
                presentationArray = state.chatRealm!.chatsArray
            }
}
    
    func getProfilePic(chat: Chat) -> [UIImage]{
        
        var imageArray = [UIImage]()
        
        let i = chat.users_in_chat.count
        
        for _ in 0...i{
            imageArray.append(UIImage(systemName: "person.circle")!)
        }
        
        return imageArray
        
    }

}
