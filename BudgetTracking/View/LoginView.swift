//
//  LoginView.swift
//  BudgetTracking
//
//  Created by Ama Ranasi on 2023-09-28.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    
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
                    Text("Hello! Login Here")
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
                        self.currentShowingView = "Create Account"
                    }
                }){
                    Text("Don't have an account? sign up")
                        .foregroundColor(.black.opacity(0.6))
                }
                
                
                
                Button{
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult{
                            print(authResult.user.uid)
                            withAnimation{
                                userID = authResult.user.uid
                            }
                        }
                        
                    }
                
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("bdcolor"))
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




