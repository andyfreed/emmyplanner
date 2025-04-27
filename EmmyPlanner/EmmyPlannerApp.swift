//
//  EmmyPlannerApp.swift
//  EmmyPlanner
//
//  Created by Andrew Freed on 4/27/25.
//

import SwiftUI

@main
struct EmmyPlannerApp: App {
    @StateObject private var partyViewModel = PartyViewModel()
    
    init() {
        // Configure the app's appearance
        configureAppAppearance()
        
        // Add debug print
        print("EmmyPlannerApp initializing")
    }
    
    var body: some Scene {
        WindowGroup {
            // For debugging - using a simple test view
            /*
            TestView()
                .onAppear {
                    print("TestView appeared")
                }
            */
            
            // Regular content view (commented out for debugging)
            ContentView()
                .environmentObject(partyViewModel)
                .background(AppTheme.backgroundPrimary)
                .accentColor(AppTheme.primaryPink)
                .onAppear {
                    print("ContentView appeared")
                }
        }
    }
    
    private func configureAppAppearance() {
        print("Configuring app appearance")
        
        // Configure UITabBar appearance
        UITabBar.appearance().tintColor = UIColor(AppTheme.primaryPink)
        
        // Configure UINavigationBar appearance
        UINavigationBar.appearance().tintColor = UIColor(AppTheme.primaryPink)
        
        // Configure UITextField appearance
        UITextField.appearance().tintColor = UIColor(AppTheme.primaryPink)
    }
}
