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
    
    // Using Core Data persistence controller
    let persistenceController = PersistenceController.shared
    
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
                // Make the persistence controller's view context available to child views
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
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
