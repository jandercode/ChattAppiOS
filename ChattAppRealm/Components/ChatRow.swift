//
//  ChatRow.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//
import SwiftUI

struct ChatRow: View {
    var chat: Chat
    var chatName: String
    var profilePic: [UIImage]
    var timestampFormatter = TimestampFormatter()
    @State var formattedTime = ""
    
    var body: some View {
        HStack {
            ZStack {
                ProfilePic(size: 45, images: profilePic)
            }
            VStack(alignment: .leading) {
                Text(chatName)
                    .lineLimit(1)
                Text(chat.last_message)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
            
            Spacer()
            Text(formattedTime)
                .font(.system(size: 12))
        }
        .padding(3)
        .onAppear{
            formattedTime = timestampFormatter.formatChatRowTimestampString(timestamp: chat.timestamp ?? Date())
        }
    }
}
