import SwiftUI

import Firebase
import FirebaseFirestoreSwift
import SwiftUICharts

struct InsightsTransaction: Identifiable, Hashable, Decodable {
    var id: String
    var date: Date
    var amount: Double
    var type: String
    var category: String
    var detail: String
    var userID: String
}
struct cchartDataEntry: Identifiable {
    var id = UUID()
    var x: Date
    var y: String

    init(x: Date, y: String) {
        self.x = x
        self.y = y
    }
}
struct InsightsView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var transactions: [InsightsTransaction] = []
    @State private var incomeTotal: Double = 0
    @State private var expenseTotal: Double = 0
    @State private var lineChartData: [cchartDataEntry] = []

    var body: some View {
        VStack {
            
                Text("Transaction Insights")
                .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 30)
            VStack(alignment: .leading){
                Text("Expense Over Time")
                    .font(.title)
                    .fontWeight(.semibold)
                
                    .padding(.bottom, 20)
                    .padding(.horizontal, 5)
            }
           Spacer()
            LineView(data: transactions.filter { $0.type == "Expense" }.map { Double($0.amount) })
            
            .frame(width: 300, height: 500)
            .padding()
            .padding(.top, 60)
            .background(Color.white)
            .cornerRadius(12)
            
            
                .frame(height: 300)
                .padding()

            .padding(.horizontal, 30)

            Spacer()
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
                    do {
                        let transaction = try document.data(as: InsightsTransaction.self)
                        return transaction
                    } catch {
                        print("Error decoding transaction: \(error.localizedDescription)")
                        return nil
                    }
                } ?? []

                // Calculate total expenses and income
                let expensesTotal = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
                let incomeTotal = transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }

                // Update income and expense totals
                self.incomeTotal = incomeTotal
                self.expenseTotal = expensesTotal

                // Generate line chart data
                self.lineChartData = generateLineChartData()

                print("Transactions loaded successfully: \(self.transactions)")
            }
        }
    }

    func generateLineChartData() -> [cchartDataEntry] {
        var chartData: [cchartDataEntry] = []
        var currentDate = Calendar.current.startOfDay(for: Date())

        for _ in 0..<30 {
            let expensesOnDate = transactions
                .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
                .filter { $0.type == "Expense" }
                .reduce(0) { $0 + $1.amount }
            let exx = String(expensesOnDate)
            chartData.append(cchartDataEntry(x: currentDate, y: exx)) // Use currentDate here
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return chartData
    }

}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
