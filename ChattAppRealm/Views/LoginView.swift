//
//  LoginView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-07.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State var eMail: String = ""
    @State var password: String = ""
    @State private var showRegisterAccount = false
    @State private var loginErrorAlert = false
    @State var saveLogin = false
    let userDao = UserDao()
    
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
                        
                       ManageLoginInfo.saveLogin(saveInfo: saveLogin)
                       login()
                        
                        
                    }, label: {
                        
                        Text("Login")
                        
                    })
                    .alert("Error logging in, check userame and password", isPresented: $loginErrorAlert) {
                        Button("Ok", role: .cancel){}
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        showRegisterAccount.toggle()
                        
                        
                    }, label: {
                        
                        Text("Register")
                        
                    })
                    .sheet(isPresented: $showRegisterAccount, content: {
                        RegisterView(eMail: $eMail, password: $password, userDao: userDao)
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
            .onAppear(){
                
                saveLogin = ManageLoginInfo.loadLogin()
                print(saveLogin)
                FirestoreContactDao.firestoreContactDao.getUsers()
                
                if(saveLogin){
                    loadUserData()
                }

            }
    }
    
    func loadUserData(){
        
        let realmUser = UserDao()
        let userLoginData = realmUser.getUser()
        
        if userLoginData[UserData.KEY_EMAIL_LOGIN] != nil && userLoginData[UserData.KEY_PASSWORD_LOGIN] != nil{
            
            eMail = userLoginData[UserData.KEY_EMAIL_LOGIN]!
            password = userLoginData[UserData.KEY_PASSWORD_LOGIN]!
            
        }
        
        login()
    }
    
    
    
    func login(){
        
        FirestoreContactDao.firestoreContactDao.checkLogin(mail: eMail, password: password)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            if UserManager.userManager.currentUser != nil{
                
                userDao.saveUser(user: UserManager.userManager.currentUser!)
                isLoggedIn = true
                
            }else{
                
                loginErrorAlert = true
            }
        })
    }
}
