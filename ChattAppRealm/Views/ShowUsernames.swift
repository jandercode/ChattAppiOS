//
//  ShowUsernames.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-25.
//

import SwiftUI

struct ShowUsernames: View {
    
    @State private var showUsernames = false
    @State var chatName : String
    
    var body: some View {
        Text(chatName)
            .padding(20)
            .onAppear() {
                self.showUsernames = true
        }
            .onDisappear {
                
            }
    }
}

