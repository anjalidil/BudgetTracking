
import SwiftUI

class ExpenseViewModel: ObservableObject {
    //properties
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var currentMonthStartDate: Date = Date()
    
    //expense/income tab
//    @Published var tabName: ExpenseType = .expense
    
    //filter view
    @Published var showFilterView: Bool = false
    
    //new expense properties
    @Published var addNewExpense: Bool = false
    
    @Published var amount: String = ""
//    @Published var type: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var remark: String = ""
    
    
    
    init(){
        //fetching current month starting date
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month], from: Date())
        
        startDate = calender.date(from: components)!
        currentMonthStartDate = calender.date(from:components)!
        
    }
    
    //a sample data of month september
    @AppStorage("uid") var userID: String = ""
    
    
    //fetching current month date string
    func currentMonthDateString()->String{
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + " - " + Date().formatted(date: .abbreviated, time: .omitted)
        
        
    }
    
   
    
    //coverting selected dates to string
    
    func convertDateToString()->String {
        return startDate.formatted(date: .abbreviated, time: .omitted) + " - " + endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    //converting number to price
    
    func converNumberToPrice(value: Double)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: value)) ?? "$0.00"
    }
    
    
    //clearing all data
    func ClearData(){
        date = Date()
      
        remark = ""
        amount = ""
    }
    
    //save data

    func saveData(){
        //do activation here
        print("Save")
    }
}

