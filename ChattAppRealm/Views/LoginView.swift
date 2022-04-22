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
                        registerView(eMail: $eMail, password: $password, userDao: userDao)
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


struct registerView: View{
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var eMail: String
    @Binding var password: String
    var userDao: UserDao
    
    @State var firstName = ""
    @State var lastName = ""
    @State var userName = ""
    @State var repeatPassword = ""
    
    @State var showSuccessAlert = false
    @State var showFailureAlert = false
    @State var showSameMailAlert = false
    
    var body: some View{
        
        VStack{
            
            TextField("username", text: $userName)
                .autocapitalization(.none)
            
            TextField("mail", text: $eMail)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            HStack{
                
                TextField("first name", text: $firstName)
                
                TextField("last name", text: $lastName)
                
            }
            
            SecureInputView("password", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureInputView("repeat password", text: $repeatPassword)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    
                    if FirestoreContactDao.firestoreContactDao.checkForSameEmail(email: eMail){
                        
                        showSameMailAlert = true
                        
                    }else if FirestoreContactDao.firestoreContactDao.checkForSameUsername(username: userName){
                        
                        showSameMailAlert = true
                        
                    }else{
                        
                        if textFieldValidatorPassword(password, repeatPassword) && textFieldValidatorEmail(eMail)
                            && !userName.isEmpty && !eMail.isEmpty && !firstName.isEmpty{
                            
                            let user = User()
                            user.username = userName
                            user.email = eMail
                            user.firstName = firstName
                            user.lastName = lastName
                            user.password = password

                            userDao.saveUser(user: user)
                            FirestoreContactDao.firestoreContactDao.saveNewUser(user: user)

                            showSuccessAlert = true
                            
                        }else{
                            
                            showFailureAlert = true
                        }
                        
                    }
                    
                    
                    
                }, label: {
                    Text("Register")
                })
                .alert("Account created", isPresented: $showSuccessAlert) {
                    Button("Great!", role: .cancel){
                        dismiss()
                    }
                }
                .alert("Something went wrong, check again", isPresented: $showFailureAlert) {
                    Button("Ok", role: .cancel){}
                }
                .alert("An account with the same E-mail or UserName already exists", isPresented: $showSameMailAlert) {
                    Button("Ok", role: .cancel){}
                }
                
                
                Spacer()
                
                Button(action: {
                    
                    dismiss()
                    
                }, label: {
                    Text("Return")
                })
                
                Spacer()
                
            }
            .buttonStyle(.bordered)
            .padding(.top)
            
        }
        .textFieldStyle(.roundedBorder)
        .padding(.leading)
        .padding(.trailing)
        
    }
    
    func textFieldValidatorPassword(_ password: String, _ repeatePassword: String) -> Bool{
        
        if password == "" || password.contains(" ") || password != repeatPassword {
            
            return false
            
        }else{
            
            return true
        }
        
        
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        
        if string.count > 100 {
            return false
            
        }
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // short format
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
        
    }
    
    
}

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
