//
//  BudgetTrackingApp.swift
//  BudgetTracking
//
//  Created by Ama Ranasi on 2023-09-27.
//


import SwiftUI
import FirebaseCore

@main
struct BudgetTrackingApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
