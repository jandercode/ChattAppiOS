//
//  BackupChatView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-26.
//

import SwiftUI

struct BackupChatView: View {
    
    @ObservedObject var state: StateController
    @State var filteredMessages = [Message]()
    
    var body: some View {
        
        VStack{
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(Array(filteredMessages.enumerated()), id: \.offset) { index, message in
                        if index >= 1 {
                            if !Calendar.current.isDate(state.messageRealm?.allMessages[index].timestamp ?? Date(), inSameDayAs: state.messageRealm?.allMessages[index-1].timestamp ?? Date()) {
                                DateRow(timestamp: message.timestamp ?? Date())
                            }
                        } else {
                            DateRow(timestamp: message.timestamp ?? Date())
                        }
                        
                        MessageRow(message: message, image: UIImage(systemName: "person.circle")!, usersInChat: state.usersInChat)
                            .id(index)
                    }
                }
                .onAppear {
                    proxy.scrollTo((filteredMessages.count) - 1, anchor: .bottom)
                }
            }
            HStack{
                
                Button {
                    
                    state.appState = .BackupPage
                    
                } label: {
                    
                    Image(systemName: "chevron.left")
                    Text("Back to backups")
                }
            }
            
            
        }.onAppear{
            
            filteredMessages = (state.messageRealm?.filteredMessages)!
            
        }
        
    }
}
