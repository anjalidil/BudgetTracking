//
//  ExpenseView.swift
//  BudgetTracking
//
//  Created by user244521 on 9/28/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Transactions: Identifiable, Hashable {
    let id: String
    let date: Date
    let amount: Double
    let type: String
    let category: String
    let remark: String
}

struct ExpenseView: View {
    
    @State private var isAddingNewExpense = false
    @AppStorage("uid") var userID: String = ""
    @State private var transactions: [Transactions] = []
//    @State private var selectedMonth = .currentMonth
    @State private var selectedTransactionType = 0
    let expenseTypeOptions = ["All", "Expense", "Income"]
    
    
//    enum TransactionType: String, CaseIterable {
//
//        case expense = "Expense"
//        case income = "Income"
//        case all: "All"
//    }
    
    
    var body: some View {
        
        ZStack{
            
            VStack {
                // Transaction Type Selector (Expenses/Income)
                Picker("Select a Time Frame", selection: $selectedTransactionType) {
                    ForEach(0..<expenseTypeOptions.count, id: \.self) { index in
                        Text(expenseTypeOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)
                
                
                VStack(alignment: .leading, spacing: 5)
                {
//                    HStack {
//                        if expenses.type == "Income" {
//                            Image(systemName: "arrow.down.circle")
//                                .foregroundColor(.green)
//                        } else if expenses.type == "Expense" {
//                            Image(systemName: "arrow.up.circle")
//                                .foregroundColor(.red)
//                        }
//                    Text(" \(String(format: "%.2f", expenses.amount))")
//                            .foregroundColor(.black)
//                        Text(" \(expenses.category)")
//                            .foregroundColor(.black)
//                        Text(expenses.type)
//                                .font(.headline)
//                                .foregroundColor(textColorForType(expenses.type))
//                    }
//                    Text(": \(expenses.remark)")
//                        .foregroundColor(.black)
//
//                    //  Spacer().frame(height: 50)
//                    Text(" \(formattedDate(expenses.date))")
//                        .foregroundColor(.black)
//
//
//
                }
                
                .padding(5)
                .background(Color.white) // Set the view's background to black
                .cornerRadius(10)
                Button(action: {
                    isAddingNewExpense.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding(16)
                }
            }
            .sheet(isPresented: $isAddingNewExpense) {
                NavigationView {
                    AddExpense()
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                isAddingNewExpense = false
                            },
                            trailing: Button("Save") {
                                isAddingNewExpense = false
                            }
                        )
                





                    .sheet(isPresented: $isAddingNewExpense) {
                                NavigationView {
                                    AddExpense()
                                        .navigationBarItems(
                                            leading: Button("Cancel") {
                                                isAddingNewExpense = false
                                            },
                                            trailing: Button("Save") {
                                                isAddingNewExpense = false
                                            }
                                        )
                                }
                                
                        }
                    }
                }
            }
        
        .ignoresSafeArea(.all)
        
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
        dateFormatter.dateFormat = "dd/mm/yyyy"
        return dateFormatter.string(from: date)
    }
}
struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
