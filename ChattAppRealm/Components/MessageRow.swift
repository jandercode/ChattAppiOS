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
    @State var stringToPrint = ""
    var timestampFormatter = TimestampFormatter()
    
    var body: some View {
        HStack {
            if message.sender != UserManager.userManager.currentUser?.id {
                ProfilePic(size: 40, image: image)
            } else {
                Spacer()
                Text(stringToPrint)
                    .font(.system(size: 12))
            }
            Text(message.text)
                .padding(10)
                .foregroundColor(message.sender == UserManager.userManager.currentUser?.id ? Color.white : Color.black)
                .background(message.sender == UserManager.userManager.currentUser?.id ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                .cornerRadius(10)
            if message.sender != UserManager.userManager.currentUser?.id {
                Text(stringToPrint)
                    .font(.system(size: 12))
                Spacer()
            }
        }.padding(.horizontal)
        .onAppear {
            stringToPrint = timestampFormatter.formatMessageRowTimestampString(timestamp: message.timestamp ?? Date())
        }
    }
}

//struct MessageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageRow()
//    }
//}
