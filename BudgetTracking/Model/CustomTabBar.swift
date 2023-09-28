import SwiftUI

enum Tabs: Int {
    case home = 0
    case expense = 1
    case insights = 2
    case budget = 3
    case profile = 4
}

struct CustomTabBar: View {
    @AppStorage("uid") var userID: String = ""
    
    @Binding var selectedTabs: Tabs

    var body: some View {
        HStack (spacing: 30) {

            Button {
                //expense
                selectedTabs = .home
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "homekit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Home")
                        .font(Font.footnote)
                }
            }
            Button {
                //expense
                selectedTabs = .expense
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "tray.and.arrow.up.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Transactions")
                        .font(Font.footnote)
                }
            }
            
            Button {
                //report
                selectedTabs = .insights
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "chart.bar.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Insights")
                        .font(Font.footnote)
                }
            }

            Button {
                //Add
                selectedTabs = .budget
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "dollarsign.arrow.circlepath")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Budget")
                        .font(Font.footnote)
                }
            }

            

            Button {
                //profile
                selectedTabs = .profile
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Profile")
                        .font(Font.footnote)
                }
            }
        }
        .frame(height: 82)
    }
}

//struct CustomTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBar()
//    }
//}
