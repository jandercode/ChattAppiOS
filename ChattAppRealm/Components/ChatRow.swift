//
//  ChatRow.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//
import SwiftUI

struct ChatRow: View {
    var chat: Chat
   // var time: String
    var read: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 45, height: 45)
                Image(systemName: "person")
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading) {
                Text("\(chat.users_in_chat[0]), \(chat.users_in_chat[1])")
                Text("last message...")
                    .font(.system(size: 15))
            }
            
            Spacer()
           // Text(time)
           // Image(systemName: read ? "circle" : "circle.fill")
        }
        .padding(3)
    }
}

//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow(chat: "Betty Sanders", time: "timestamp", read: false)
//    }
//}
