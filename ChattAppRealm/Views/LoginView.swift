//
//  LoginView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-07.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var state: StateController
    
    let userManager = UserManager.userManager
    
    @State var eMail: String = ""
    @State var password: String = ""
    @State private var showRegisterAccount = false
    @State var saveLogin = false
    @State var isLoading = false
    @State private var error: ErrorInfo?
    @State var isConnected = false

    var body: some View {
        
        VStack{
            
            Text("LOGIN")
                .font(.largeTitle)
            
            TextField("E-mail", text: $eMail)
                .padding()
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureInputView("Password", text: $password)
                .padding()
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    
                    if isConnected{
                        
                        let userDao = RealmUserDao()
                        userDao.eraseUserData()
                        ManageLoginInfo.saveLogin(saveInfo: saveLogin)
                        login()
                        
                    }else{
                        
                        error = ErrorInfo(id: 1, title: "Offline", description: "Connection error, check your internet connection")
                    }
                    
                }, label: {
                    
                    Text("Login")
                    
                }).alert(item: $error, content: { error in
                    
                    Alert(
                        
                        title: Text(error.title),
                        message: Text(error.description)
                    )
                })
                
                Spacer()
                
                Button(action: {
                    
                    if isConnected{
                        showRegisterAccount.toggle()
                    }else{
                        error = ErrorInfo(id: 1, title: "Offline", description: "Connection error, check your internet connection")
                    }
                }, label: {
                    
                    Text("Register")
                    
                }).alert(item: $error, content: { error in
                    
                    Alert(
                        
                        title: Text(error.title),
                        message: Text(error.description)
                    )
                })
                    .sheet(isPresented: $showRegisterAccount, content: {
                        RegisterView(eMail: $eMail, password: $password)
                    })
                
                Spacer()
                
            }
            .buttonStyle(.bordered)
            .padding(.top)
            
            
            HStack(){
                
                Toggle("Remember Me?", isOn: $saveLogin)
                    .padding(.leading, CGFloat(70))
                    .padding(.trailing, CGFloat(70))
                
            }
            .padding()
            .ignoresSafeArea()
            
        }
        .sheet(isPresented: $isLoading, content: {
            LoadingAnimation(state: state, error: $error)
        })
        .onAppear(){
            
            FirestoreUserDao.firestoreContactDao.getUsers()
            userManager.currentUser = nil
            saveLogin = ManageLoginInfo.loadLogin()
            print("save login \(saveLogin)")
            
            if(saveLogin){
                loadUserData()
            }
            
            if Reachability.isConnectedToNetwork(){
                isConnected = true
            } else {
                isConnected = false
            }
        }
    }
    
    func loadUserData(){
        
        let realmUser = RealmUserDao()
        realmUser.getUser()
        let userLoginData = realmUser.user
        
        if userLoginData[UserData.KEY_EMAIL_LOGIN] != nil && userLoginData[UserData.KEY_PASSWORD_LOGIN] != nil{
            
            eMail = userLoginData[UserData.KEY_EMAIL_LOGIN]!
            password = userLoginData[UserData.KEY_PASSWORD_LOGIN]!
            state.appState = .Chats
            
        }else{
            
            saveLogin = false
            ManageLoginInfo.saveLogin(saveInfo: saveLogin)
        }
    }
    
    
    func login(){
        
        isLoading = true
        
        FirestoreUserDao.firestoreContactDao.checkLogin(mail: eMail, password: password)
        
        loginQueue {
            moveToChats()
        }
    }
    
    func moveToChats(){
        
        if userManager.currentUser != nil && userManager.currentUser?.firstName != "error"{
            
            isLoading = false
            
        }else{
            
            userManager.currentUser = nil
            isLoading = false
            
        }
    }
    
    func loginQueue(onComplete: @escaping () -> Void){
        
        let queue = DispatchQueue(label: "myQueue")
        queue.async{
            
            while userManager.currentUser == nil{
                continue
            }
            print("exited")
            onComplete()
        }
    }
}
