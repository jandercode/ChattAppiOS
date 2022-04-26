//
//  BackupView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-26.
//

import SwiftUI

struct BackupView: View {
    
    @ObservedObject var state: StateController
    
    var body: some View {
        
        VStack{
            
            List{
                
                ForEach (state.chatRealm!.chatsArray){ chat in
                    
                    ChatRow(chat: chat, chatName: FirestoreChatDao.firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), profilePic: UIImage(systemName: "person.circle")! ,read: false)
                    
                        .listRowSeparator(.hidden)
                    
                }
            }
            
        }.onAppear{
            
            if state.chatRealm == nil{
                state.chatRealm = RealmChatDao()
            }
        }
    }
}

