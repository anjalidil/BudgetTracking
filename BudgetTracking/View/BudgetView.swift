

import SwiftUI
import Firebase
import FirebaseFirestore

struct ExpenseCategory: Identifiable, Hashable {
    var id: String?
    var name: String
}

struct BudgetView: View {
    @State private var isAlertShowing = false
    @AppStorage("uid") var userID: String = ""
    @State private var categories: [ExpenseCategory] = []
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var note: String = ""

    @State private var selectedCategoryIndex = 0

    var selectedCategory: ExpenseCategory? {
        if categories.indices.contains(selectedCategoryIndex) {
            return categories[selectedCategoryIndex]
        }
        return nil
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
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Note", text: $note)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Picker("Category", selection: $selectedCategoryIndex) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index].name)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding(20)
                
                Button(action: {
                    handleCreate()
                }) {
                    Text("Submit Expense")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(20)
                
                Spacer()
            }
            .onAppear {
                // Fetch categories for the AddView when it appears
                loadCategoriesForAddView()
            }
        }
    }

    func loadCategoriesForAddView() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser

        guard let userUID = user?.uid else {
            print("User is not authenticated.")
            return
        }

        let userCategoriesRef = db.collection("users").document(userUID).collection("categories")

        userCategoriesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
            } else {
                if let documents = snapshot?.documents {
                    self.categories.removeAll()

                    for document in documents {
                        let data = document.data()
                        if let name = data["name"] as? String,
                           let color = data["color"] as? String {
                            // Ensure that the "id" field is retrieved as a string
                            let id = document.documentID
                            let category = ExpenseCategory(id: id, name: name)
                            self.categories.append(category)
                        }
                    }
                }
            }
        }
    }

    func handleCreate() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser

        guard let userUID = user?.uid else {
            print("User is not authenticated.")
            return
        }

        guard let selectedCategory = selectedCategory else {
            print("No category selected.")
            return
        }

        guard let amountDouble = Double(amount) else {
            print("Invalid amount.")
            return
        }

        let expenseData: [String: Any] = [
            "amount": amountDouble,
            "date": date,
            "note": note,
            "category": selectedCategory.name
        ]

        db.collection("users").document(userUID).collection("expenses").addDocument(data: expenseData) { error in
            if let error = error {
                print("Error adding expense: \(error.localizedDescription)")
            } else {
                print("Expense added successfully.")
                // Reset the form fields
                amount = ""
                date = Date()
                note = ""
            }
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
    }
}

