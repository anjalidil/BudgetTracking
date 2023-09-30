//
//  BudgetHistory.swift
//  BudgetTracking
//
//  Created by user244521 on 9/30/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct BudgetTransaction: Identifiable, Hashable, Decodable {
    var id: String
    var month: String
    var amount: Double
    var category: String
    var userID: String
}

struct BudgetHistory: View {
    
    @AppStorage("uid") var userID: String = ""
    @State private var transactions: [BudgetTransaction] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    Text("Budget History")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.bottom, 17)
                        .padding(.horizontal, 30)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    List(transactions) { transaction in
                        HStack {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(" \(transaction.month)")
                                            .foregroundColor(.black)
                                            .font(.title3)
                                        
                                        Text(" \(transaction.category)")
                                            .foregroundColor(.black)
                                            .font(.footnote)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        HStack {
                                            Text(" ")
                                                .foregroundColor(.primary)
                                            
                                            Text(String(format: "%.2f", transaction.amount))
                                                .foregroundColor(.primary)
                                                .font(.title3)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .onAppear {
                fetchTransactions()
            }
        }
    }
    
    func fetchTransactions() {
        let db = Firestore.firestore()
        var query = db.collection("Budget").whereField("userID", isEqualTo: userID)

        // You may want to add additional filters here, if needed

        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                self.transactions = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    if let month = data["month"] as? String,
                       let amount = data["amount"] as? Double,
                       let category = data["category"] as? String {
                        return BudgetTransaction(id: document.documentID,  month: month, amount: amount,  category: category,  userID: self.userID)
                    }
                    return nil
                } ?? []

                // Group transactions by month
                let groupedTransactions = Dictionary(grouping: transactions, by: { $0.month })

                // Sort the months
                let sortedMonths = groupedTransactions.keys.sorted()

                // Display the transactions by month
                sortedMonths.forEach { month in
                    if let transactionsForMonth = groupedTransactions[month] {
                        // You can display the transactions for each month here
                        // Example: Print the month and the transactions
                        print("Month: \(month)")
                        transactionsForMonth.forEach { transaction in
                            print("Amount: \(transaction.amount), Category: \(transaction.category)")
                        }
                    }
                }

                print("Transactions loaded successfully: \(self.transactions)")
            }
        }
    }
}
