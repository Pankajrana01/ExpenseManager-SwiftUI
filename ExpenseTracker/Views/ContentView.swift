//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 02/04/25.
//

import SwiftUI

/// The main content view that hosts the tab-based navigation for the app.
///
/// This view displays the `DashboardView`, `TransactionsView`, and `InsightsView`
/// as separate tabs, allowing users to switch between core sections of the app.
struct ContentView: View {
    /// The environment-injected instance of `DatabaseManager`.
    ///
    /// This is used to interact with the current database implementation,
    /// which may be local, in-memory, or Firebase-based depending on the selected `DatabaseType`.
    @Environment(DatabaseManager.self) var databaseManager
    
    /// The `TabManager` is injected from the environment and used to track the currently selected tab index.
    @EnvironmentObject var tabManager: TabManager
    
    @State private var isLoading = false
    @State private var presentedSheet: PresentedSheet? = nil
    @State private var refreshTrigger = UUID() // Add this for triggering refresh

    /// The body of the `ContentView`, which defines a `TabView` to display multiple sections of the app.
    ///
    /// The `selection` binding to `tabManager.selectedTabIndex` allows dynamic switching between tabs programmatically.
    
    var body: some View {
           ZStack(alignment: .bottom) {
               // Main content area that changes based on selected tab
               Group {
                   switch tabManager.selectedTabIndex {
                   case 0:
                       DashboardView(databaseManager: databaseManager)
                           .id(refreshTrigger) // This will force dashboard to refresh
                   case 1:
                       TransactionsView(databaseManager: databaseManager)
                           .id(refreshTrigger) // Refresh transactions too
                   case 2:
                       InsightsView(databaseManager: databaseManager)
                           .id(refreshTrigger) // Refresh insights too
                   case 3:
                       SettingsView(databaseManager: databaseManager)
                   default:
                       DashboardView(databaseManager: databaseManager)
                           .id(refreshTrigger)
                   }
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .ignoresSafeArea(.all) // fill behind tab bar

               // Custom curved tab bar
               CurvedTabBar(
                   tabManager: tabManager,
                   selectedTabIndex: $tabManager.selectedTabIndex,
                   presentedSheet: $presentedSheet,
                   databaseManager: databaseManager,
                   onDataRefresh: { // Add the missing callback
                       // This will trigger a refresh by changing the ID
                       refreshTrigger = UUID()
                   }
               )
           }
           .ignoresSafeArea(.keyboard, edges: .bottom)
           .sheetPresenter(
            presentedSheet: $presentedSheet,
            onExpenseAdd: {
                // Refresh when expense is added via sheet
                refreshTrigger = UUID()
            },
            onIncomeAdd: {
                // Refresh when income is added via sheet
                refreshTrigger = UUID()
            },
            onExpenseUpdate: {
                // Refresh when expense is updated
                refreshTrigger = UUID()
            },
            onIncomeUpdate: {
                // Refresh when income is updated
                refreshTrigger = UUID()
            }
           )
       }
        
}

#Preview {
    ContentView()
        .environmentObject(TabManager())
        .environment(DatabaseManager.initWithInMemory)
        .environment(\.authenticator, FirebaseAuthenticator())
        .environment(NotificationManager(center: .init(), settings: NotificationSettingsHandler()))
}
