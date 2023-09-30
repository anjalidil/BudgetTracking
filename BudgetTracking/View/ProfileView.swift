//
//  ProfileView.swift
//  BudgetTracking
//
//  Created by user244521 on 9/28/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var userEmail: String? // Add a state property to hold the user's email
    @State private var isCategoryViewPresented = false
    
    var body: some View {
        
        if userID == "" {
            AuthView()
        } else {
            List {
                Section {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                            .foregroundColor(Color(.white))
                            .frame(width: 65, height: 65)
                            .background(Color(.systemGray))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userEmail ?? "Unknown") // Display the user's email or "Unknown" if it's not available
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                        }
                    }
                }
                
                Section("Configurations") {
                    Button {
                        isCategoryViewPresented.toggle()
                    } label: {
                        ProfileRowVIew(imageName: "list.clipboard.fill",
                                       title: "Categories",
                                       tintColor: .cyan)
                    }
                    .sheet(isPresented: $isCategoryViewPresented) {
                        NavigationView {
                            AddExpense()
                                .navigationBarItems(
                                    leading: Button("Cancel") {
                                        isCategoryViewPresented = false
                                    }
                                )
                        }
                    }
                }
                
                Section("Account") {
                    Button(action: {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            withAnimation {
                                userID = ""
                            }
                            
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    }) {
                        ProfileRowVIew(imageName: "power.circle.fill",
                                       title: "Sign Out",
                                       tintColor: .red)
                    }
                }
                
                Section("General") {
                    HStack {
                        ProfileRowVIew(imageName: "gear",
                                       title: "Version",
                                       tintColor: Color(.systemGray))
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
            }
            .onAppear {
                fetchUserEmail() // Fetch and update the user's email when the view appears
            }
        }
    }
    
    // Function to fetch the user's email from Firebase Authentication
    private func fetchUserEmail() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
