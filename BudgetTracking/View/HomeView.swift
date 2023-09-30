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
    var isFilter: Bool = false
    @State private var incomeTotal: Double = 0 // Declare incomeTotal here
    @State private var expenseTotal: Double = 0
    @State private var currentMonthDateString = ""

    // Chart Data
    @State private var chartDatas: [Double] = [0, 0] // Initialize with default values
    
    var body: some View {
        VStack {
            
            HStack(alignment: .top){
                Text("MyMoney")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 17)
                    .padding(.horizontal, 30)
                Spacer()
                
            }
           
            GeometryReader{proxy in
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        .linearGradient(colors: [
                            Color("homeblue"),
                            Color("bdcolor"),
                            Color("homecolor"),
                            
                            
                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                VStack(spacing: 20){
                    VStack(spacing: 15){
                        
                        //currently going month date string
                        Text( currentMonthDateString)
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        //current month transaction difference
                        Text("\(calculateDifference())")
                            .font(.system(size: 35, weight: .bold))
                        
                            .lineLimit(1)
                            .padding(.bottom, 5)
                        
                        
                    }
                    
                    .offset(y: -10)
                    HStack(spacing: 15){
                        Image(systemName: "arrow.down.circle.fill")
                            .imageScale(.large)
                            .font(.caption.bold())
                            .foregroundColor(.green)
                            .frame(width: 30, height: 30)
                            .background(.white, in: Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Income")
                                .font(.caption)
                                .opacity(0.7)
                            //print totalIncome
                            Text(String(format: "%.2f", incomeTotal))
                                .font(.callout)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .fixedSize()
                            
                        }
                        
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Image(systemName: "arrow.up.circle.fill")
                            .imageScale(.large)
                            .font(.caption.bold())
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                            .background(.white.opacity(0.8), in: Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Expenses")
                                .font(.caption)
                                .opacity(0.7)
                            //print totalExpense
                            Text(String(format: "%.2f", expenseTotal))
                            
                                .font(.callout)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .fixedSize()
                            
                        }
                        
                        
                    }
                    
                    .padding(.horizontal)
                    .padding(.trailing)
                    .offset(y: 15)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 230)
            .padding(.top)
            .padding(.horizontal, 10)
            
         
            // Display the Bar Chart
            BarChartView(data: ChartData(values: [
                ("Expenses", chartDatas[0]),
                ("Income", chartDatas[1])
            ]), title: "Expenses vs. Income")
            .frame(width: 500, height: 300)
           
            
            
                        
            
            
        }
        .onAppear {
            fetchTransactions()
            
            // Set the currentMonthDateString when the view appears
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy" // Format to display the month and year
            currentMonthDateString = dateFormatter.string(from: Date())
            
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
                expenseTotal = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
                incomeTotal = transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
                
                // Update chart data
                chartDatas = [expenseTotal, incomeTotal]
                
                print("Transactions loaded successfully: \(self.transactions)")
            }
        }
    }
    
    func calculateDifference() -> Double {
        let expensesTotal = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
        let incomeTotal = transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
        let difference = expensesTotal - incomeTotal
            return (difference * 100).rounded() / 100
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
