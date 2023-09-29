//import SwiftUI
//import Firebase
//import FirebaseFirestore
//
//struct Category: Identifiable, Hashable {
//    var id: String?
//    var name: String
//}
//
//struct CategoryAmount {
//    var category: Category
//    var amount: String
//}
//
//struct BudgetView: View {
//    @State private var isAlertShowing = false
//    @AppStorage("uid") var userID: String = ""
//    @State private var categories: [Category] = []
//    @State private var month: String = ""
//    @State private var selectedCategoryIndices: Set<Int> = []
//    @State private var categoryAmounts: [CategoryAmount] = []
//
//    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
//
//    var body: some View {
//        if userID == "" {
//            AuthView()
//        } else {
//            VStack {
//                HStack {
//                    Image(systemName: "dollarsign.arrow.circlepath")
//                        .imageScale(.large)
//                        .padding(.top, 23)
//                    Text("Monthly Budget")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .padding(.top, 20)
//                }
//
//                VStack(alignment: .leading, spacing: 20) {
//                    Text("Select Month")
//                    Picker("Month", selection: $month) {
//                        ForEach(months, id: \.self) { month in
//                            Text(month).tag(month)
//                        }
//                    }
//                    .pickerStyle(WheelPickerStyle())
//                    .padding(10)
//
//                    ForEach(categories, id: \.id) { category in
//                        HStack {
//                            Text(category.name)
//                            Spacer()
//                            Spacer()
//                            Spacer()
//                            TextField("Amount", text: Binding(
//                                get: {
//                                    getCategoryAmount(category: category)
//                                },
//                                set: { newValue in
//                                    setCategoryAmount(category: category, amount: newValue)
//                                }
//                            ))
//
//                        }
//                    }
//                }
//                .padding(20)
//
//                Button(action: {
//                    // Create budget documents for selected categories in the "Budget" collection
//                    for index in selectedCategoryIndices {
//                        let selectedCategoryAmount = categoryAmounts[index]
//                        let amountString = selectedCategoryAmount.amount // Unwrapped safely
//                        if let amount = Double(amountString) {
//                            let budgetData: [String: Any] = [
//                                "month": month,
//                                "amount": amount,
//                                "category": selectedCategoryAmount.category.name
//                            ]
//
//                            Firestore.firestore().collection("Budget").addDocument(data: budgetData) { error in
//                                if let error = error {
//                                    print("Error adding document to Firestore: \(error)")
//                                } else {
//                                    print("Document added to Firestore successfully.")
//                                }
//
//                            }
//                        }
//                    }
//
//                    // Clear the input fields
//                    month = ""
//                    categoryAmounts = []
//                    selectedCategoryIndices.removeAll()
//                }){
//                    Text("Create Budget")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color("bdcolor"))
//                        .cornerRadius(10)
//                }
//                .padding(20)
//
//                Spacer()
//            }
//            .onAppear {
//                // Fetch categories for the Picker from Firestore
//                Firestore.firestore().collection("Category").getDocuments { (querySnapshot, error) in
//                    if let error = error {
//                        print("Error fetching categories: \(error)")
//                    } else {
//                        for document in querySnapshot!.documents {
//                            if let categoryName = document["name"] as? String {
//                                categories.append(Category(id: document.documentID, name: categoryName))
//                                categoryAmounts.append(CategoryAmount(category: Category(id: document.documentID, name: categoryName), amount: ""))
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private func getCategoryAmount(category: Category) -> String {
//        if let index = categoryAmounts.firstIndex(where: { $0.category.id == category.id }) {
//            return categoryAmounts[index].amount ?? ""
//        }
//        return ""
//    }
//
//    private func setCategoryAmount(category: Category, amount: String) {
//        if let index = categoryAmounts.firstIndex(where: { $0.category.id == category.id }) {
//            categoryAmounts[index].amount = amount
//        }
//    }
//}
//
//struct BudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetView()
//    }
//}

import SwiftUI
import Firebase
import FirebaseFirestore

struct Category: Identifiable, Hashable {
    var id: String?
    var name: String
}

struct BudgetView: View {
    
    @State private var isAlertShowing = false
    @AppStorage("uid") var userID: String = ""
    @State private var categories: [Category] = []
    @State private var month: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var note: String = ""
    
    @State private var selectedCategoryIndex = 0
    
    
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
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

       // Firestore reference to the "Budget" collection
       private var budgetCollection: CollectionReference {
           return Firestore.firestore().collection("Budget")
       }
    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            VStack {
                HStack{
                    Image(systemName: "dollarsign.arrow.circlepath")
                        .imageScale(.large)
                        .padding(.top, 23)
                    Text("Monthly Budget")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                }
                
                
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Select Month")
                    Picker("Month", selection: $month){
                        ForEach(months, id: \.self){month in
                            Text(month).tag(month)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding(10)
                    
                    Picker("Category", selection: $selectedCategoryIndex) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index].name)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(20)
                
                Button(action: {
                                   // Create a budget document in the "Budget" collection
                                   let budgetData: [String: Any] = [
                                       "month": month,
                                       "amount": Double(amount) ?? 0.0,
                                      
                                       "category": selectedCategory?.name ?? ""
                                   ]

                                   budgetCollection.addDocument(data: budgetData) { error in
                                       if let error = error {
                                           print("Error adding document: \(error)")
                                       } else {
                                           // Clear the input fields
                                           month = ""
                                           amount = ""
                                          
                                           selectedCategoryIndex = 0
                                       }
                                   }
                               }) {
                    Text("Create Budget")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("bdcolor"))
                        .cornerRadius(10)
                }
                .padding(20)
                
                Spacer()
            }
            .onAppear {
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
            }
            

    

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
    }
}

