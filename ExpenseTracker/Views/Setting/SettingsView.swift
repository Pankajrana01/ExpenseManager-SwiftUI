//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 14/08/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false

    @EnvironmentObject var tabManager: TabManager
    
    /// Initializes the `InsightsView` with a given database manager.
    /// - Parameter databaseManager: Object conforming to `DatabaseManager` to handle data operations.
    init(databaseManager: DatabaseManager) {
       // self._viewModel = .init(initialValue: .init(databaseManager: databaseManager))
    }
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Account Section
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView()) {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    NavigationLink(destination: Text("Change Password")) {
                        Label("Change Password", systemImage: "lock.circle")
                    }
                }
                
                // MARK: - Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Enable Notifications", systemImage: "bell.badge")
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }
                
                // MARK: - About Section
                Section(header: Text("About")) {
                    NavigationLink(destination: Text("App Version: 1.0.0")) {
                        Label("Version", systemImage: "info.circle")
                    }
                    NavigationLink(destination: Text("Terms & Privacy")) {
                        Label("Terms & Privacy", systemImage: "doc.text")
                    }
                }
                
                // MARK: - Logout Button
                Section {
                    Button(role: .destructive) {
                        // Handle logout
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

// Dummy profile view
struct ProfileView: View {
    var body: some View {
        Text("User Profile")
            .navigationTitle("Profile")
    }
}

#Preview {
    SettingsView(databaseManager: .initWithInMemory)
        .environmentObject(TabManager())
        .environment(DatabaseManager.initWithInMemory)
        .environment(\.authenticator, FirebaseAuthenticator())
        .environment(NotificationManager(center: .init(), settings: NotificationSettingsHandler()))
}
