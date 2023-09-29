//
//  AddExpense.swift
//  BudgetTracking
//
//  Created by user244521 on 9/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AllTypes: Identifiable{
    var id: String
    
    var type: String
    var detail: String
    var date: Date
    var amount: Double
    var category: String
}
// Category model
struct category: Identifiable, Hashable {
    var id: String?
    var name: String
}
// Transaction model
struct Transaction: Identifiable, Codable {
    var id: String
    var userID: String
    var type: String
    var date: Date
    var amount: Double
    var category: String
    var detail: String
    
        
    // Constructor with all required arguments
    init(id: String, userID: String, type: String, date: Date, amount: Double, category: String, detail: String  ) {
        self.id = id
        self.userID = userID
        self.type = type
        self.date = date
        self.amount = amount
        self.category = category
        self.detail = detail
        
        
    }
}



struct AddExpense: View {
    @AppStorage("uid") var userID: String = ""
    @State private var selectedDate = Date()
    @State private var type = ""
    @State private var category = ""
    @State private var detail = ""
    @State private var amount = ""
    @State private var categories: [Category] = []
    @State private var selectedCategoryIndex = 0
    @State private var isShowingListView = false // State to control navigation

    let typeOptions = ["Income", "Expense"]
   
    
    @State private var selectedType = "Income" // Initial selection

    
    
    var selectedCategory: Category? {
        if categories.indices.contains(selectedCategoryIndex) {
            return categories[selectedCategoryIndex]
        }
        return nil
    }
    // Firestore reference to the "Category" collection
       private var categoriesCollection: CollectionReference {
           return Firestore.firestore().collection("Category")
       }
    
    // Firestore reference to the "Transaction" collection
       private var transactionsCollection: CollectionReference {
           return Firestore.firestore().collection("Transaction")
       }
    

    var body: some View {
        NavigationView {
            Form {
               
                Section{
                    Picker("Type", selection: $selectedType) {
                        ForEach(typeOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        .padding()
                    
                    TextField("Amount", text: $amount)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                    
                    Picker("Category", selection: $selectedCategoryIndex) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index].name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(10)
                    
                    .cornerRadius(10)

//

                    

                    TextField("Details", text: $detail)
                        .foregroundColor(.black)
                        .textFieldStyle(.automatic)
                        
                        
                    Button(action: {
                        addTransactionToFirestore()
                        selectedType = "Income"
                                selectedCategoryIndex = 0
                                selectedDate = Date()
                                detail = ""
                                amount = ""
                    }) {
                        Text("Add Transaction")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("bdcolor"))
                            .cornerRadius(10)
                            
                            
                    }
                }
    
            }
            .navigationBarTitle("Add New Transactions")
                        .onAppear {
//                            UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 10)] // Adjust the font size as needed
                            // Fetch categories for the Picker from Firestore
                            categoriesCollection.getDocuments { (querySnapshot, error) in
                                if let error = error {
                                    print("Error fetching categories: \(error)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        if let categoryName = document["name"] as? String {
                                            categories.append(Category(id: document.documentID, name: categoryName))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
    // Function to add a transaction to Firestore
       private func addTransactionToFirestore() {
           // Create a new transaction object based on your form values
           let newTransaction = Transaction(
               id: UUID().uuidString,
               userID: userID,
               type: selectedType,
               date: selectedDate,
               amount: Double(amount) ?? 0.0,
               category: selectedCategory?.name ?? "", // Use the selected category name
               detail: detail
               
               
           )

           // Add the new transaction to Firestore
           do {
               try transactionsCollection.addDocument(from: newTransaction)
               // Optionally, you can perform additional actions after adding the transaction
               // For example, reset form fields or show a confirmation message
               
           } catch {
               print("Error adding transaction: \(error.localizedDescription)")
           }
       }
            }
            

                
struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense()
    }
}
