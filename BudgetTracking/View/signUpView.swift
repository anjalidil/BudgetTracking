

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
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("Create an Account")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack{
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        //.fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                )
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    TextField("Password", text: $password)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        //.fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                )
                .padding()
                
                Button(action: {
                    withAnimation{
                        self.currentShowingView = "login"
                    }
                }){
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                }
                Spacer()
                Spacer()
                
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
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
            }
            
            
        }
    }
}




