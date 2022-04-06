//
//  ChatRow.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//
import SwiftUI

struct ChatRow: View {
    var chat: String
    var time: String
    var read: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                Image(systemName: "person")
                    .foregroundColor(.white)
            }
            Text(chat)
            Spacer()
            Text(time)
            Image(systemName: read ? "circle" : "circle.fill")
        }
        .padding()
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: "Betty Sanders", time: "timestamp", read: false)
    }
}
