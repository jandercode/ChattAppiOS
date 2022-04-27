//
//  LoadingAnimation.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-22.
//

import SwiftUI

struct LoadingAnimation: View {
    
    @State private var isLoading = false
    @ObservedObject var state: StateController
    @Binding var error: ErrorInfo?
    
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.green, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
                }
        }
        .onDisappear{
            
            if UserManager.userManager.currentUser != nil && UserManager.userManager.currentUser?.firstName != "error"{
                
                state.loginLogic()
                
            }else{
                
                error = ErrorInfo(id: 1, title: "Error", description: "Error logging in, check the fields")
                
            }
            
        }
    }
}
