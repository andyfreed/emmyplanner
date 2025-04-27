//
//  ContentView.swift
//  EmmyPlanner
//
//  Created by Andrew Freed on 4/27/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: PartyViewModel
    
    var body: some View {
        TabView {
            PartyDetailsView()
                .tabItem {
                    Label("Party Info", systemImage: "balloon.fill")
                }
            
            GuestListView()
                .tabItem {
                    Label("Guests", systemImage: "person.3.fill")
                }
            
            ThemePlanningView()
                .tabItem {
                    Label("Theme", systemImage: "wand.and.stars.fill")
                }
            
            GoodyBagView()
                .tabItem {
                    Label("Goody Bags", systemImage: "gift.fill")
                }
        }
        .accentColor(AppTheme.primaryPink)
        .onAppear {
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            
            // Apply the appearance to tab bar
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PartyViewModel())
}
