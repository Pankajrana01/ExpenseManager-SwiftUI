//
//  OnboardingView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 27/08/25.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Dependencies & App State
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0

    @State private var authenticator = FirebaseAuthenticator()
    @State private var databaseManager = DatabaseManager.initWithUserDefaults
    @State private var tabManager = TabManager()
    @State private var notificationManager = NotificationManager(center: .init(), settings: NotificationSettingsHandler())

    @State private var showMainContent = false

    // MARK: - Onboarding Pages
    let onboardingPages = [
        OnboardingPage(
            title: "Spend Squish",
            subtitle: "Spend Squish helps you track spending, cut unnecessary costs, and manage payments—all in one place. Stay organized and in control of your money.",
            iconName: "wallet",
            gradientColors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")]
        ),
        OnboardingPage(
            title: "Track\nSpending",
            subtitle: "Stay on top of every transaction with clear insights, detailed breakdowns, and smart charts that show exactly where your money is going.",
            iconName: "cart",
            gradientColors: [Color(hex: "#3E63D5"), Color(hex: "#484CB8"), Color(hex: "#474BB9")]
        ),
        OnboardingPage(
            title: "Squish Your Budget",
            subtitle: "Create personalized budgets for different goals, set spending limits, and get gentle reminders to help you save and reach financial freedom.",
            iconName: "chart",
            gradientColors: [Color(hex: "#5200AE"), Color(hex: "#5200AE"), Color(hex: "#4062BB")]
        )
    ]

    // MARK: - Body
    var body: some View {
        Group {
            if showMainContent {
                ContentView()
                    .environment(databaseManager)
                    .environment(\.authenticator, authenticator)
                    .environmentObject(tabManager)
                    .environment(notificationManager)
            } else {
                onboardingUI
            }
        }
        .onAppear {
            if UserDefaults.standard.hasLaunchedBefore {
                // Skip onboarding if already launched
                Task {
                    await performAppSetup()
                    withAnimation {
                        showMainContent = true
                    }
                }
            }
        }
    }

    // MARK: - Onboarding UI
    private var onboardingUI: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: onboardingPages[currentPage].gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentPage)

                VStack(spacing: 0) {
                    // TabView for onboarding pages
                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            OnboardingPageView(page: onboardingPages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)

                    // Page indicator & buttons
                    VStack(spacing: 30) {
                        // Page indicator
                        HStack(spacing: 8) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                                    .scaleEffect(currentPage == index ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                            }
                        }

                        // Navigation buttons
                        HStack {
                            if currentPage > 0 {
                                Button(action: previousPage) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("PREVIOUS")
                                    }
                                    .font(AppFont.poppins(.medium, size: 16))
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.white.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                }
                            }

                            Button(action: continueOrNext) {
                                HStack {
                                    Text(currentPage == onboardingPages.count - 1 ? "CONTINUE" : "NEXT")
                                    if currentPage < onboardingPages.count - 1 {
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .font(AppFont.poppins(.medium, size: 16))
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.white.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }

    // MARK: - Navigation Logic
    private func continueOrNext() {
        if currentPage < onboardingPages.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                currentPage += 1
            }
        } else {
            // Final screen: Continue to app
            UserDefaults.standard.hasLaunchedBefore = true
            Task {
                await performAppSetup()
                withAnimation {
                    showMainContent = true
                }
            }
        }
    }

    private func previousPage() {
        if currentPage > 0 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                currentPage -= 1
            }
        }
    }

    // MARK: - Setup Logic
    private func performAppSetup() async {
        if case let .firebase(userId) = UserDefaults.standard.databaseType {
            databaseManager.initializeRemoteRepositoryHandler(firestoreRepositoryHandler(userId: userId))
        }
        let isAuthorized = await notificationManager.requestPermission()
        if isAuthorized {
            await notificationManager.scheduleDailyExpenseNotification()
        }
    }
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isVisible = false
    @State private var titleOffset: CGFloat = 20
    @State private var subtitleOffset: CGFloat = 80
    @State private var iconScale: CGFloat = 0.3
    @State private var iconRotation: Double = -180
    @State private var textOpacity: Double = 0

    var body: some View {
        VStack {
            Spacer()
            
            // Icon with animations
            ZStack {
                FadingGlowCircle()
                        .frame(width: 300, height: 300)
                getIconView()
                    .foregroundColor(.white)
                    .scaleEffect(iconScale)
                    .rotationEffect(.degrees(iconRotation))
            }
            
            Spacer()
            
            // Title and subtitle
            VStack(spacing: 10) {
                Text(page.title)
                    .font(AppFont.poppins(.bold, size: 38))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .offset(y: titleOffset)
                    .opacity(textOpacity)
                
                Text(page.subtitle)
                    .font(AppFont.poppins(.regular, size: 18))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .offset(y: subtitleOffset)
                    .opacity(textOpacity)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .onAppear { startEntrance() }
        .id(page.title)
    }

    private func startEntrance() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            iconScale = 1.0
            iconRotation = 0
        }
        withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.2)) {
            titleOffset = 0
            textOpacity = 1.0
        }
        withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.4)) {
            subtitleOffset = 0
        }
    }

    @ViewBuilder
    private func getIconView() -> some View {
        switch page.iconName {
        case "wallet":
            Image("wallet")
        case "cart":
            Image("shopping")
        case "chart":
            Image("planing")
        default:
            Image("wallet")
        }
    }
}

struct FadingGlowCircle: View {
    @State private var glowOpacity: Double = 0.5

    var body: some View {
        Circle()
            .fill(Color.white.opacity(glowOpacity))
            .blur(radius: 25)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glowOpacity = 0.15
                }
            }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let iconName: String
    let gradientColors: [Color]
}

// Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}


