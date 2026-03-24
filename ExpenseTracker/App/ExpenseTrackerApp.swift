//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 27/03/25.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

/// The main entry point of the Expense Tracker application.
///
/// This struct conforms to the `App` protocol, which defines the structure and behavior
/// of the app. The `@main` attribute indicates that this is the starting point.
@main
struct ExpenseTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    /// The body that defines the scene (UI container) for the app.
    ///
    /// - `WindowGroup` creates a scene that presents a window for the app’s content.
    /// - `SplashScreenView` is the initial view shown when the app launches.
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
