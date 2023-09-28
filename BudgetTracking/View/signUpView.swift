

import SwiftUI
import FirebaseAuth
//import Firebase

struct SignUpView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
//    init() {
//        FirebaseApp.configure()
//    }
//
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack{
                    Image("logo1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 230, height: 200)
                        .padding(.vertical, 5)
                }
                
                HStack{
                    Text("Create an Account")
                        .font(.title)
                        .bold()
                    
                    
                }
                .padding()
               
                
                HStack{
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    
                }
                
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color("bdcolor"))
                )
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    TextField("Password", text: $password)
                    
                    Spacer()
                    
                    
                }
                
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color("bdcolor"))
                )
                .padding()
                
                Button(action: {
                    withAnimation{
                        self.currentShowingView = "login"
                    }
                }){
                    Text("Already have an account? Log in")
                        .foregroundColor(.black.opacity(0.6))
                }
               
                
                Button{
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error{
                            print(error)
                            return
                        }

                        if let authResult = authResult{
                            print(authResult.user.uid)
                            userID = authResult.user.uid
                            
                        }
                        
                    }
                
                } label: {
                    Text("Create New Account")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
                Spacer()
                Spacer()
                HStack{
                    Text("Copyright@2023 MyMoney. All rights reserved.")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.6))
                }
                        
            }
            
            
        }
    }
}




