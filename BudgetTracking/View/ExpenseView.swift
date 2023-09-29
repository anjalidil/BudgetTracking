import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ExpenseTransaction: Identifiable, Hashable, Decodable {
    var id: String
    var date: Date
    var amount: Double
    var type: String
    var category: String
    var detail: String
    var userID: String
}

struct ExpenseView: View {
    
    @State private var isAddingNewExpense = false
    @AppStorage("uid") var userID: String = ""
    @State private var transactions: [ExpenseTransaction] = []
    @State private var selectedTransactionType = 0
    let expenseTypeOptions = ["All", "Expense", "Income"]
    
    // Date range selection
    @State private var startDate: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
        
        @State private var endDate: Date = {
            let lastDayOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: Date())
            return lastDayOfMonth ?? Date()
        }()
    
    var filteredTransactions: [ExpenseTransaction] {
           if selectedTransactionType == 0 {
               // Show all transactions
               return transactions.filter { transaction in
                               transaction.date >= startDate && transaction.date <= endDate
                           }
           } else {
               // Show filtered transactions based on the selected type
               let selectedType = expenseTypeOptions[selectedTransactionType]
               return transactions.filter { transaction in
                   transaction.type == selectedType && transaction.date >= startDate && transaction.date <= endDate
               }
           }
       }
    var body: some View {
        
            VStack(alignment: .leading) {
                Text("Transactions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 17)
                    .padding(.horizontal, 30)
                
                    
                HStack{
                    DatePicker("", selection: $startDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal, 16)
                        .font(.system(size: 12))
                    
                    DatePicker("to ", selection: $endDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal, 16)
                        .font(.system(size: 18))
                }
                .padding(.bottom, 17)
                HStack {
                    Picker("Select transaction type", selection: $selectedTransactionType) {
                        ForEach(0..<expenseTypeOptions.count, id: \.self) { index in
                            Text(expenseTypeOptions[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(10)
                    
                    
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    List(filteredTransactions) { transaction in
                        HStack {
                            VStack {
                                HStack {
                                    VStack {
                                        Text(" \(transaction.category)")
                                            .foregroundColor(.black)
                                            .padding(0.6)
                                            .font(.title3)
                                        
                                        Text(" \(transaction.detail)")
                                            .foregroundColor(.black)
                                            .font(.footnote)
                                        Text(" \(formattedDate(transaction.date))")
                                            .foregroundColor(.black.opacity(0.6))
                                            .font(.footnote)
                                    }
                                    Spacer()
                                    VStack {
                                        HStack {
                                            if transaction.type == "Income" {
                                                Text("+")
                                                    .foregroundColor(.green)
                                            } else if transaction.type == "Expense" {
                                                Text("-")
                                                    .foregroundColor(.red)
                                                    .padding(0.6)
                                            }
                                            
                                            Text(" \(String(format: "%.2f", transaction.amount))")
                                                .foregroundColor(textColorForType(transaction.type))
                                                .font(.title3)
                                        }
                                        Text(" \(formattedDate(transaction.date))")
                                            .foregroundColor(.black.opacity(0.6))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                    }
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    isAddingNewExpense.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Color("bdcolor"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding(16)
                }
                .sheet(isPresented: $isAddingNewExpense) {
                    NavigationView {
                        AddExpense()
                            .navigationBarItems(
                                leading: Button("Cancel") {
                                    isAddingNewExpense = false
                                }
                            )
                    }
                }
            }
            .onAppear {
                fetchTransactions()
            
        }
    }
    
    func fetchTransactions() {
        let db = Firestore.firestore()
        var query = db.collection("Transaction").whereField("userID", isEqualTo: userID)
        
        query = query.whereField("date", isGreaterThanOrEqualTo: startDate)
                          .whereField("date", isLessThanOrEqualTo: endDate)
        
        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                self.transactions = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    if let amount = data["amount"] as? Double,
                       let dateTimestamp = data["date"] as? Timestamp,
                       let detail = data["detail"] as? String,
                       let category = data["category"] as? String,
                       let typeString = data["type"] as? String
                    {
                        let date = dateTimestamp.dateValue()
                        return ExpenseTransaction(id: document.documentID, date: date, amount: amount, type: typeString, category: category, detail: detail, userID: self.userID)
                    }
                    return nil
                } ?? []
                print("Transactions loaded successfully: \(self.transactions)")
            }
        }
    }
    
    func textColorForType(_ type: String) -> Color {
        if type == "Income" {
            return .green
        } else if type == "Expense" {
            return .red
        } else {
            return .primary
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
