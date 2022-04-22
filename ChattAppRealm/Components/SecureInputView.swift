//
//  SecureTextField.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-22.
//

import SwiftUI

struct SecureInputView: View {
    
    @Binding private var password: String
    @State private var isSecured: Bool = true
    
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        
        self.title = title
        self._password = text
        
    }
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $password)
                    
                } else {
                    TextField(title, text: $password)
                    
                }
                
            }.padding(.trailing, 32)
            Button(action: {
                isSecured.toggle()
                
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                .accentColor(.gray)
                
            }
            
        }
        
    }
}
