//
//  ContentView.swift
//  BudgetTracking
//
//  Created by Ama Ranasi on 2023-09-27.
//
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    @State var selectedTab: Tabs = .home
    var body: some View {
        if userID == "" {
            AuthView()
            
        } else {
            TabView(selection: $selectedTab) {
                HomeView()
                        .tabItem {
                        Label("Home", systemImage: "homekit")
                    }
                    .tag(Tabs.home)
              
//                AddView()
                ExpenseView()
                    .tabItem {
                        Label("Transactions", systemImage: "tray.and.arrow.up.fill")
                    }
                    .tag(Tabs.expense)
                
                InsightsView()
                    .tabItem {
                        Label("Insights", systemImage: "chart.bar.fill")
                                    }
                    .tag(Tabs.insights)
                
                BudgetView()
                    .tabItem {
                        Label("Budget", systemImage: "dollarsign.arrow.circlepath")
                    }
                    .tag(Tabs.budget)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(Tabs.profile)
            }
            .accentColor(Color("bdcolor")) // Set the tab bar color
            
            //CustomTabBar(selectedTabs: $selectedTab)
        }
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
