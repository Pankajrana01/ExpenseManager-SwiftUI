//
//  CustomTabBar.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 14/08/25.
//

import SwiftUI
struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let mid = rect.width / 2
        let curveHeight: CGFloat = 45
        let curveWidth: CGFloat = 70
        
        // Start bottom-left
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        // Left flat edge to start of curve
        path.addLine(to: CGPoint(x: mid - curveWidth, y: 0))
        
        // First curve (up)
        path.addCurve(
            to: CGPoint(x: mid, y: curveHeight),
            control1: CGPoint(x: mid - curveWidth/2, y: 0),
            control2: CGPoint(x: mid - curveWidth/2, y: curveHeight)
        )
        
        // Second curve (down)
        path.addCurve(
            to: CGPoint(x: mid + curveWidth, y: 0),
            control1: CGPoint(x: mid + curveWidth/2, y: curveHeight),
            control2: CGPoint(x: mid + curveWidth/2, y: 0)
        )
        
        // Right flat edge
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        // Close shape
        path.closeSubpath()
        
        return path
    }
}

struct CurvedTabBar: View {
    @ObservedObject var tabManager: TabManager
    @Binding var selectedTabIndex: Int
    @Binding var presentedSheet: PresentedSheet?
    @State private var showAddOptions = false
    
    let databaseManager: DatabaseManager
    let onDataRefresh: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Background shape
            CurvedShape()
                .fill(.white)
                .shadow(color: .orange1.opacity(0.15), radius: 8, x: 0, y: -5)
                .frame(height: 70 + 30)
               // .ignoresSafeArea(.container, edges: .bottom)
                .overlay(
                    HStack {
                        TabBarButton(icon: "home", selectedIcon: "home-selected", index: 0, tabManager: tabManager)
                        Spacer()
                        
                        TabBarButton(icon: "list", selectedIcon: "list-selected", index: 1, tabManager: tabManager)
                            .offset(x: 10)
                        Spacer()
                        
                        // MARK: - Center Button
                            
                        Button {
                            showAddOptions = true
                        } label: {
                            Image("add-button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 95, height: 95)
                        }
                        .offset(y: -40)
                        .sheet(isPresented: $showAddOptions) {
                            AddExpenseIncomeBottomSheet(
                                onAddIncome: {
                                    presentedSheet = .addIncome(databaseManager)
                                },
                                onAddExpense: {
                                    presentedSheet = .addExpense(databaseManager)
                                },
                                onDataChanged: {
                                    onDataRefresh?()
                                }
                            )
                            .presentationDetents([.height(400), .medium])
                            .presentationDragIndicator(.visible)
                        }
                        Spacer()
                        
                        TabBarButton(icon: "analytics", selectedIcon: "analytics-selected", index: 2, tabManager: tabManager)
                            .offset(x: -10)
                        Spacer()
                        
                        TabBarButton(icon: "more", selectedIcon: "more-selected", index: 3, tabManager: tabManager)
                    }
                    .padding(.horizontal, 30)
                )
        }
        .ignoresSafeArea(.all)
        .padding(.bottom, -35)
    }
}

struct TabBarButton: View {
    let icon: String
    let selectedIcon: String
    let index: Int
    @ObservedObject var tabManager: TabManager
    
    @State private var isAnimating = false
    
    var body: some View {
        let isSelected = tabManager.selectedTabIndex == index
        
        Button {
            tabManager.selectedTabIndex = index
            
            // Bounce animation
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        } label: {
            ZStack(alignment: .top) {
                // Icon
                Image(isSelected ? selectedIcon : icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .scaleEffect(isSelected && isAnimating ? 1.2 : 1.0)
                
                // Circle indicator
                if isSelected {
                    Circle()
                        .fill(Color.orange1) // Change color if needed
                        .frame(width: 10, height: 10)
                        .offset(x: 0, y: -15) // Position slightly outside top-right corner
                        .transition(.scale) // Nice appearing effect
                }
            }
        }
    }
}

// MARK: - Bottom Sheet Implementation

struct AddExpenseIncomeBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: String? = nil
    
    // Closure actions
    let onAddIncome: () -> Void
    let onAddExpense: () -> Void
    let onDataChanged: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header section
            VStack(spacing: 12) {
                // Title
                Text("Track Your Money")
                    .font(AppFont.poppins(.bold, size: 20))
                    .foregroundColor(.primary)
                
                // Description
                Text("Add expenses or income to stay organized and in control of your spending with Spend Squish")
                    .font(AppFont.poppins(.regular, size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 24)
            .padding(.bottom, 32)
            
            // Options section
            VStack(spacing: 16) {
                // Add Income Button
                OptionButton(
                    title: "Add Income",
                    description: "Record money earned",
                    icon: "arrow.up.circle.fill",
                    color: .green,
                    isSelected: selectedOption == "income"
                ) {
                    selectedOption = "income"
                    handleIncomeAction()
                }
                // Add Expense Button
                OptionButton(
                    title: "Add Expense",
                    description: "Record money spent",
                    icon: "arrow.down.circle.fill",
                    color: .red,
                    isSelected: selectedOption == "expense"
                ) {
                    selectedOption = "expense"
                    handleExpenseAction()
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Cancel button
            VStack(spacing: 16) {
                Button("Cancel") {
                    dismiss()
                }
                .font(AppFont.poppins(.medium, size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, 50)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
        .background(Color(.systemBackground))
    }
    
    private func handleExpenseAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
            onAddExpense()
            // Call refresh after sheet presents
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onDataChanged()
            }
        }
    }
    
    private func handleIncomeAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
            onAddIncome()
            // Call refresh after sheet presents
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onDataChanged()
            }
        }
    }
}

struct OptionButton: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .foregroundColor(.black.opacity(0.3))
                    .imageScale(.large)
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFont.poppins(.semiBold, size: 16))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(description)
                        .font(AppFont.poppins(.regular, size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Arrow indicator
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? color : Color(.systemGray4),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                    .shadow(
                        color: isSelected ? color.opacity(0.2) : Color.black.opacity(0.05),
                        radius: isSelected ? 8 : 2,
                        x: 0,
                        y: isSelected ? 4 : 1
                    )
            )
        }
        .buttonStyle(CustomButtonStyle())
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            isPressed = pressing
        } perform: {
            // Long press action if needed
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
