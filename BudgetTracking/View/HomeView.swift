import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SwiftUICharts

struct HomeTransactions: Identifiable, Hashable, Decodable {
    var id: String
    var date: Date
    var amount: Double
    var type: String
    var category: String
    var detail: String
    var userID: String
}

struct HomeView: View {
    
    @State private var isAddingNewExpense = false
    @AppStorage("uid") var userID: String = ""
    @State private var transactions: [HomeTransactions] = []
    @State private var selectedTransactionType = 0
    let expenseTypeOptions = ["All", "Expense", "Income"]
    
    // Chart Data
    @State private var chartData: [Double] = [0, 0] // Initialize with default values
    
    var body: some View {
        VStack {
            Text("Difference: \(calculateDifference())")
                .padding()
            // Display the Bar Chart
            BarChartView(data: ChartData(values: [
                ("Expenses", chartData[0]),
                ("Income", chartData[1])
            ]), title: "Expenses vs. Income")
            .frame(width: 500, height: 300)
            .padding()
            
            
            
           
        }
        .onAppear {
            fetchTransactions()
        }
    }
    
    func fetchTransactions() {
        let db = Firestore.firestore()
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        var query = db.collection("Transaction").whereField("userID", isEqualTo: userID)
        query = query.whereField("date", isGreaterThanOrEqualTo: startOfMonth)
                     .whereField("date", isLessThanOrEqualTo: endOfMonth)
        
        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                self.transactions = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    if let amount = data["amount"] as? Double,
                       let typeString = data["type"] as? String {
                        return HomeTransactions(id: document.documentID, date: Date(), amount: amount, type: typeString, category: "", detail: "", userID: self.userID)
                    }
                    return nil
                } ?? []
                
                // Calculate total expenses and income
                let expensesTotal = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
                let incomeTotal = transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
                
                // Update chart data
                chartData = [expensesTotal, incomeTotal]
                
                print("Transactions loaded successfully: \(self.transactions)")
            }
        }
    }
    
    func calculateDifference() -> Double {
        let expensesTotal = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
        let incomeTotal = transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
        return expensesTotal - incomeTotal
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
