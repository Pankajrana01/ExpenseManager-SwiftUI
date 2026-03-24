//
//  SplashScreenView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 27/03/25.
//

import SwiftUI

/// A view that represents the splash screen of the application.
///
/// This view is displayed initially when the app launches. It shows a logo and the app's name ("Expense Tracker"),
/// with a fade-out animation before transitioning to the main content view (i.e., `ContentView`).
/// The splash screen lasts for 1 second before transitioning to the main screen.
///
/// - **Appearance**:
///   - The splash screen background color changes based on the system's color scheme (dark or light mode).
///   - A logo is displayed at the center with a fade-out animation.
///   - The app's name "Expense Tracker" is shown below the logo.
struct SplashScreenView: View {
    /// An instance of `Authenticator` that handles authentication and user state.
    /// Using `@State` keeps it alive during the lifetime of the scene.
    @State private var authenticator = FirebaseAuthenticator()
    
    /// State variable holding the current database switcher instance.
    /// This determines which database (in-memory, local, Firebase) the app should use.
    @State private var databaseManager = DatabaseManager.initWithUserDefaults
    
    /// An instance of `TabManager` that tracks the selected tab index throughout the app.
    ///
    /// It's marked with `@State` to maintain its lifecycle and ensure it stays alive across view updates.
    /// It's injected into the environment so any view in the app hierarchy can access and modify it.
    @State private var tabManager = TabManager()
    
    /// Handles all local notification scheduling and permission logic.
    @State private var notificationManager = NotificationManager(center: .init(), settings: NotificationSettingsHandler())
    
    /// A state variable that determines whether the splash screen should be active or not.
    /// When `isActive` is true, the main `ExpenseListView` is shown.
    @State private var isActive = false
    
    /// The current color scheme of the system (dark or light mode).
    /// Used to adjust the background color of the splash screen.
    @Environment(\.colorScheme) var colorScheme
    
    @State private var startedButtonShown: Bool = false
    
    @State private var animateOpacity = false

    var body: some View {
        // If the splash screen is not active, show the splash screen with logo and app name.
        if isActive {
            // Transition to the main content view once the splash screen is done.
            /// - `.environment(tabManager)` injects the `TabManager` into the view hierarchy.
            /// - `.environment(authenticator)` injects the `FirebaseAuthenticator` into the view hierarchy.
            /// - `.environment(databaseManager)` injects the `DatabaseManager` into the view hierarchy.
            
            ContentView()
                .task {
                    if case let .firebase(userId) = UserDefaults.standard.databaseType {
                        databaseManager.initializeRemoteRepositoryHandler(firestoreRepositoryHandler(userId: userId))
                    }
                    Task {
                        let isAuthorized = await notificationManager.requestPermission()
                        if isAuthorized {
                            await notificationManager.scheduleDailyExpenseNotification()
                        }
                    }
                }
                .environment(databaseManager)
                .environment(\.authenticator, authenticator)
                .environmentObject(tabManager)
                .environment(notificationManager)
        } else {
            ZStack {
                // Set background color based on color scheme (dark or light mode).
                (colorScheme == .dark ? Color.black : Color.white)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Logo image that fades out when the splash screen transitions.
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .opacity(isActive ? 0 : 1)  // Fades out when isActive becomes true.
                        .animation(.easeInOut(duration: 1.0), value: isActive)
                    // App title text.
                    VStack {
                        Text("SpendSquish")
                            .font(AppFont.poppins(.extraBold, size: 40))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                            .foregroundStyle(colorScheme == .dark ? .white : .black1)  // Custom text color.
                        
                        Text("Squish your spend, boost your bliss, and solve all your payment problems in one place.")
                            .font(AppFont.poppins(.regular, size: 14))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                            .foregroundStyle(colorScheme == .dark ? .white : .lightGrey1)  // Custom text color.
                    } //.padding(.all, 20)
                    
                    // Show "Get Started" only if first launch
                    if startedButtonShown {
                        Button(action: {
                            print("Get Started tapped")
                            UserDefaults.standard.hasLaunchedBefore = true
                            isActive = true
                        }) {
                            Text("Get Started")
                                .font(AppFont.poppins(.regular, size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.purple1)
                                .cornerRadius(25)
                                .padding(.horizontal, 30)
                        }
                    } else {
                        Text("Fetching details...")
                            .font(AppFont.poppins(.regular, size: 14))
                            .foregroundColor(Color.purple1)
                            .opacity(animateOpacity ? 1 : 0.3) // Fade animation
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.2).repeatForever(autoreverses: true)) {
                                    animateOpacity.toggle()
                                }
                            }
                    }
                    Spacer()
                }
            }
            .onAppear {
                // After 1 second, set isActive to true to trigger the transition to the main screen.
                if UserDefaults.standard.hasLaunchedBefore {
                    startedButtonShown = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isActive = true
                    }
                } else {
                    startedButtonShown = true
                }
            }
        }
    }
}


#Preview {
    SplashScreenView()
}
