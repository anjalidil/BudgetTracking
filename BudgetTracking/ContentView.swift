//
//  ContentView.swift
//  BudgetTracking
//
//  Created by Ama Ranasi on 2023-09-27.
//

import SwiftUI
import FirebaseAuth


struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == "" {
            
            AuthView()
        }else {
            Text("Logged In! \nYour User ID is: \(userID)")
            
            Button(action: {
                let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                    withAnimation{
                        userID = ""
                    }
                    
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                }
            }){
                Text("Sign Out")
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
