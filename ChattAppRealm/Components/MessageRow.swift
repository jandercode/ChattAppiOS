//
//  MessageRow.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-12.
//

import SwiftUI

struct MessageRow: View {
    var message : Message
    var image: UIImage
    @State var formattedTimestamp = ""
    var timestampFormatter = TimestampFormatter()
    var usersInChat : [String]
    
    var body: some View {
        VStack {
            if usersInChat.count > 2 {
                if message.sender != UserManager.userManager.currentUser?.id {
                    Text(getUsername(userId: message.sender))
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 66)
                        .padding(.top, 5)
                }
            }
            
            HStack {
                if message.sender != UserManager.userManager.currentUser?.id {
                    ProfilePic(size: 40, images: [image])
                } else {
                    Spacer()
                    Text(formattedTimestamp)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                Text(message.text)
                    .padding(10)
                    .foregroundColor(message.sender == UserManager.userManager.currentUser?.id ? Color.white : Color.black)
                    .background(message.sender == UserManager.userManager.currentUser?.id ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                    .cornerRadius(10)
                
                if message.sender != UserManager.userManager.currentUser?.id {
                    Text(formattedTimestamp)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Spacer()
                }
            }.padding(.horizontal)
        }
        .onAppear {
            formattedTimestamp = timestampFormatter.formatMessageRowTimestampString(timestamp: message.timestamp ?? Date())
        }
    }
    
    func getUsername(userId : String) -> String {
        for user in FirestoreContactDao.firestoreContactDao.registeredUsers{
            
            if userId == user.id {
                
                return user.username
                
            }
        }
        return ""
    }
}
