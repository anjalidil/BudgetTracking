//import SwiftUI
//import SwiftUICharts
//import Firebase
//import FirebaseFirestoreSwift
//import Charts
//
//struct InsightsTransaction: Identifiable, Hashable, Decodable {
//    var id: String
//    var date: Date
//    var amount: Double
//    var type: String
//    var category: String
//    var detail: String
//    var userID: String
//}
//struct ChartDataEntry: Identifiable {
//    var id = UUID()
//    var x: Double
//    var y: Double
//
//    init(x: Double, y: Double) {
//        self.x = x
//        self.y = y
//    }
//}
//let currentDate = Date()
//let calendar = Calendar.current
//let dayOfMonth = Double(calendar.component(.day, from: currentDate))
//let expensesOnDate = 100.0 // Replace with your actual expense value
//
//let chartDataEntry = ChartDataEntry(x: dayOfMonth, y: expensesOnDate)
//struct InsightsView: View {
//    @AppStorage("uid") var userID: String = ""
//    @State private var transactions: [InsightsTransaction] = []
//    @State private var incomeTotal: Double = 0
//    @State private var expenseTotal: Double = 0
//    @State private var lineChartData: [ChartDataEntry] = []
//
//    var body: some View {
//         VStack {
//             LineChart(data: lineChartData, title: "Expenses Over Time")
//                 .frame(height: 300)
//                 .padding()
//
//             HStack {
//                 VStack {
//                     Text("Income")
//                         .font(.headline)
//                         .foregroundColor(.green)
//                     Text(String(format: "%.2f", incomeTotal))
//                         .font(.subheadline)
//                         .foregroundColor(.green)
//                 }
//                 .frame(width: 100, alignment: .trailing)
//
//                 VStack {
//                     Text("Expenses")
//                         .font(.headline)
//                         .foregroundColor(.red)
//                     Text(String(format: "%.2f", expenseTotal))
//                         .font(.subheadline)
//                         .foregroundColor(.red)
//                 }
//                 .frame(width: 100, alignment: .trailing)
//             }
//             .padding(.horizontal, 30)
//
//             Spacer()
//         }
//         .onAppear {
//             fetchTransactions()
//         }
//     }
//    func fetchTransactions() {
//        let db = Firestore.firestore()
//        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
//        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
//
//        var query = db.collection("Transaction").whereField("userID", isEqualTo: userID)
//        query = query.whereField("date", isGreaterThanOrEqualTo: startOfMonth)
//                     .whereField("date", isLessThanOrEqualTo: endOfMonth)
//
//        query.addSnapshotListener { (querySnapshot, error) in
//            if let error = error {
//                print("Error fetching transactions: \(error.localizedDescription)")
//            } else {
//                self.transactions = querySnapshot?.documents.compactMap { document in
//                    do {
//                        let transaction = try document.data(as: InsightsTransaction.self)
//                        return transaction
//                    } catch {
//                        print("Error decoding transaction: \(error.localizedDescription)")
//                        return nil
//                    }
//                } ?? []
//
//                // Calculate total expenses and income
//                let expensesTotal = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
//                let incomeTotal = transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
//
//                // Update income and expense totals
//                self.incomeTotal = incomeTotal
//                self.expenseTotal = expensesTotal
//
//                // Generate line chart data
//                self.lineChartData = generateLineChartData()
//
//                print("Transactions loaded successfully: \(self.transactions)")
//            }
//        }
//    }
//
//    func generateLineChartData() -> [ChartDataEntry] {
//        var chartData: [ChartDataEntry] = []
//        var currentDate = Calendar.current.startOfDay(for: Date())
//
//        for _ in 0..<30 {
//            let expensesOnDate = transactions
//                .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
//                .filter { $0.type == "Expense" }
//                .reduce(0) { $0 + $1.amount }
//
//            chartData.append(ChartDataEntry(x: dayOfMonth, y: expensesOnDate)) // Use dayOfMonth here
//            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
//        }
//
//        return chartData
//    }
//}
//
//struct InsightsView_Previews: PreviewProvider {
//    static var previews: some View {
//        InsightsView()
//    }
//}
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SwiftUICharts

struct InsightsTransactions: Identifiable, Hashable, Decodable {
    var id: String
    var date: Date
    var amount: Double
    var type: String
    var category: String
    var detail: String
    var userID: String
}

struct ChartDataPoint {
    var value: Double
    var label: String
}

struct InsightsView: View {
    
    @State private var isAddingNewExpense = false
    @AppStorage("uid") var userID: String = ""
    @State private var transactions: [InsightsTransactions] = []
    @State private var selectedTransactionType = 0
    let expenseTypeOptions = ["All", "Expense", "Income"]
    
    // Custom Chart Data
    @State private var customChartData: [ChartDataPoint] = [
        ChartDataPoint(value: 0, label: "Expenses"),
        ChartDataPoint(value: 0, label: "Income")
    ]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Transaction Insights")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 17)
                    .padding(.horizontal, 30)
                Spacer()
            }
            
            // Display the Horizontal Bar Chart
            HBarChart(dataPoints: customChartData, legend: "Expenses vs. Income")
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjust to fit the screen
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
                        return InsightsTransactions(id: document.documentID, date: Date(), amount: amount, type: typeString, category: "", detail: "", userID: self.userID)
                    }
                    return nil
                } ?? []
                
                // Calculate total expenses and income
                let expensesTotal = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
                let incomeTotal = transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
                
                // Update custom chart data
                customChartData = [
                    ChartDataPoint(value: expensesTotal, label: "Expenses"),
                    ChartDataPoint(value: incomeTotal, label: "Income")
                ]
                
                print("Transactions loaded successfully: \(self.transactions)")
            }
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}

