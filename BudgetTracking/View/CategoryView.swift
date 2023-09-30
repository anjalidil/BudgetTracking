import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

// Category model
struct Categry: Identifiable, Hashable, Encodable {
    var id: String?
    var name: String
    var type: String
}

struct CategoryView: View {
    @AppStorage("uid") var userID: String = ""
    
    @State private var category = ""
    @State private var selectedType = "Income" // Initial selection
    
    @State private var categories: [Categry] = []
    
    // Firestore reference to the "Category" collection
    private var categoriesCollection: CollectionReference {
        return Firestore.firestore().collection("Category")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Type", selection: $selectedType) {
                        Text("Income").tag("Income")
                        Text("Expense").tag("Expense")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    TextField("Category", text: $category)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                    
                    Button(action: {
                        // Ensure the category name is not empty before adding it
                        if !category.isEmpty {
                            // Create a new category object
                            let newCategory = Categry(name: category, type: selectedType)
                            
                            // Add the new category to Firestore
                            addCategory(newCategory)
                            
                            // Clear the category text field
                            category = ""
                        }
                        fetchCategories()
                    }) {
                        Text("Add Category")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("bdcolor"))
                            .cornerRadius(10)
                    }
                }
                
                Section(header: Text("Categories")) {
                    List(categories) { category in
                        Text(category.name)
                    }
                }
            }
            .navigationBarTitle("Add New Categories")
            .onAppear {
                // Fetch categories from Firestore
                fetchCategories()
            }
        }
    }
    
    // Function to add a category to Firestore
    func addCategory(_ category: Categry) {
        do {
            _ = try categoriesCollection.addDocument(from: category)
        } catch {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
    // Function to fetch categories from Firestore
    func fetchCategories() {
        categoriesCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                return
            }
            
            if let documents = querySnapshot?.documents {
                self.categories = documents.compactMap { document in
                    let data = document.data()
                    if let name = data["name"] as? String, let type = data["type"] as? String {
                        return Categry(id: document.documentID, name: name, type: type)
                    }
                    return nil
                }
            }
        }
    }
    






}
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
