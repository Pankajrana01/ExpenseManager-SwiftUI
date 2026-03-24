//
//  TransactionsView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 02/04/25.
//

import SwiftUI

///// A reusable view that displays a set of filter options in a horizontally scrollable list.
///// Tapping a filter will toggle its selection and trigger a callback to display relevant UI.
//struct FilterView: View {
//    /// A binding to the set of currently selected filter options.
//    @Binding var selectedFilterOptions: Set<FilterOption>
//    
//    /// A callback executed when a filter option is selected or deselected.
//    var onSelectFilterOption: ((FilterOption) -> Void)
//    
//    private var highlightGradient: some ShapeStyle {
//        LinearGradient(
//            gradient: Gradient(colors: [
//                Color(hex: "#F58374"),
//                Color(hex: "#C65B93"),
//                Color(hex: "#A5509D")
//            ]),
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )
//    }
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(FilterOption.allCases, id: \.self) { filterOption in
//                    Button {
//                        // Toggle filter option selection.
//                        if selectedFilterOptions.contains(filterOption) {
//                            selectedFilterOptions.remove(filterOption)
//                        } else {
//                            onSelectFilterOption(filterOption)
//                        }
//                    } label: {
//                        HStack(spacing: 10) {
//                            Text(filterOption.rawValue)
//                            if selectedFilterOptions.contains(filterOption) {
//                                Image(systemName: "xmark.circle.fill")
//                            }
//                        }
//                    }
//                    .tint(selectedFilterOptions.contains(filterOption) ? .primary.opacity(0.8) : .gray)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 15)
//                    .background(selectedFilterOptions.contains(filterOption) ? .green1.opacity(0.3) : .primary.opacity(0.1))
//                    .clipShape(.capsule)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.bottom, 5)
//        }
//    }
//}


/// A modern, animated view that displays filter options in a horizontally scrollable list.
/// Features smooth animations, gradient styling, and haptic feedback.
struct FilterView: View {
    /// A binding to the set of currently selected filter options.
    @Binding var selectedFilterOptions: Set<FilterOption>
    
    /// A callback executed when a filter option is selected or deselected.
    var onSelectFilterOption: ((FilterOption) -> Void)
    
    /// Animation state for entrance effects
    @State private var hasAppeared = false
    
    /// Custom gradient colors
    private let gradientColors = [
        Color(hex: "#F58374"),
        Color(hex: "#C65B93"),
        Color(hex: "#A5509D")
    ]
    
    /// Highlight gradient for selected filters
    private var highlightGradient: some ShapeStyle {
        LinearGradient(
            colors: gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Subtle gradient for unselected filters
    private var subtleGradient: some ShapeStyle {
        LinearGradient(
            colors: [Color(.systemGray6), Color(.systemGray5)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(Array(FilterOption.allCases.enumerated()), id: \.element) { index, filterOption in
                    FilterChip(
                        option: filterOption,
                        isSelected: selectedFilterOptions.contains(filterOption),
                        gradientColors: gradientColors,
                        animationDelay: Double(index) * 0.1
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            toggleFilter(filterOption)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
        .frame(height: 50) // Fixed height to prevent extra space
        .scrollClipDisabled()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                hasAppeared = true
            }
        }
    }
    
    /// Toggles the selection state of a filter option with haptic feedback.
    private func toggleFilter(_ filterOption: FilterOption) {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        if selectedFilterOptions.contains(filterOption) {
            selectedFilterOptions.remove(filterOption)
        } else {
            onSelectFilterOption(filterOption)
        }
    }
}

/// A modern, animated chip representing a single filter option.
struct FilterChip: View {
    let option: FilterOption
    let isSelected: Bool
    let gradientColors: [Color]
    let animationDelay: Double
    let action: () -> Void
    
    @State private var hasAppeared = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                action()
            }
        }) {
            HStack(spacing: 8) {
                // Filter icon (if available)
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(isSelected ? .white : .primary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                // Filter text
                Text(option.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                // Remove indicator for selected filters
                if isSelected {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 16, height: 16)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, isSelected ? 14 : 12)
            .padding(.vertical, isSelected ? 8 : 6)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    } else {
                        LinearGradient(colors: [Color(.systemGray6), Color(.systemGray5)], startPoint: .top, endPoint: .bottom)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ?
                        Color.clear :
                        Color(.systemGray4),
                        lineWidth: isSelected ? 0 : 0.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(
                isPressed ? 0.95 :
                (isSelected ? 1.05 : (hasAppeared ? 1.0 : 0.8))
            )
            .shadow(
                color: isSelected ? (gradientColors.first?.opacity(0.3) ?? .clear) : .clear,
                radius: isSelected ? 6 : 0,
                x: 0, y: isSelected ? 3 : 0
            )
            .opacity(hasAppeared ? 1.0 : 0.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(animationDelay)) {
                hasAppeared = true
            }
        }
    }
}

// MARK: - FilterOption Extension for Icons
extension FilterOption {
    /// Returns an appropriate SF Symbol icon for each filter option
    var icon: String? {
        switch self {
        case .date:
            return "calendar"
        case .category:
            return "folder"
        case .amount:
            return "dollarsign.circle"
        case .source:
            return "banknote"
        default:
            return nil
        }
    }
}

/// A view that represents the header for a section of transactions grouped by month and year.
/// Displays the year, month, and total expense for the period.
struct TransactionListSectionHeaderView: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let transactions: [any Transaction]
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            HStack {
                let components = title.components(separatedBy: " ")
                let month = components.first ?? ""
                let year = components.last ?? ""
                VStack(alignment: .leading) {
                    Text("\(year)")
                        .font(AppFont.poppins(.regular, size: 14))
                    
                    Text("\(month)")
                        .font(AppFont.poppins(.medium, size: 25))
                }
                Spacer()
                Text("\(transactions.totalExpense, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    .font(AppFont.poppins(.medium, size: 25))
            }
            .foregroundStyle(colorScheme == .dark ? .white : .white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.primary.opacity(0.1))
        }
    }
}

/// A polymorphic view that displays either an expense or income item
/// based on the type of the given transaction.
struct TransactionItemView: View {
    let transaction: any Transaction
    
    var body: some View {
        if let expense = transaction as? Expense {
            ExpenseItemView(expense: expense)
        } else if let income = transaction as? Income {
            IncomeItemView(income: income)
        } else {
            Text("Unknown Transaction Type")
                .foregroundStyle(.red)
                .font(.footnote)
        }
    }
}

/// A view that displays and manages all transaction records, with support for filtering, editing, and deleting.
struct TransactionsView: View {
    
    /// ViewModel that manages the state and logic for transactions.
    @State private var viewModel: ViewModel
    
    /// Initializes the TransactionsView with a provided database manager.
    init(databaseManager: DatabaseManager) {
        _viewModel = .init(initialValue: .init(databaseManager: databaseManager))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                /// Filter options view allowing users to select filters.
                FilterView(selectedFilterOptions: $viewModel.selectedFilterOptions) { filterOption in
                    switch filterOption {
                    case .date:
                        viewModel.presentedSheet = .showDateFilter
                    case .source:
                        viewModel.presentedSheet = .showIncomeSource
                    case .category:
                        viewModel.presentedSheet = .showExpenseCategory
                    case .amount:
                        viewModel.presentedSheet = .showAmountRange
                    }
                }
                
                /// List displaying grouped transactions by month and year.
                List {
                    ForEach(viewModel.sectionKeys, id: \.self) { key in
                        if let transactions = viewModel.groupedTransactionList[key] {
                            // Section header
                            TransactionListSectionHeaderView(title: key, transactions: transactions)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                            
                            /// Display each transaction, with swipe actions for editing and deleting.
                            ForEach(transactions, id: \.id) { transaction in
                                TransactionItemView(transaction: transaction)
                                    .swipeActions {
                                        Button("Delete", systemImage: "trash") {
                                            if let expense = transaction as? Expense {
                                                viewModel.alertType = .deleteExpense(expense)
                                            } else if let income = transaction as? Income {
                                                viewModel.alertType = .deleteIncome(income)
                                            }
                                        }
                                        .tint(.red1.opacity(0.9))
                                        
                                        Button("Edit", systemImage: "pencil") {
                                            if let expense = transaction as? Expense {
                                                viewModel.presentedSheet = .editExpense(viewModel.databaseManager, expense)
                                            } else if let income = transaction as? Income {
                                                viewModel.presentedSheet = .editIncome(viewModel.databaseManager, income)
                                            }
                                        }
                                        .tint(.green1.opacity(0.8))
                                    }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .searchable(text: $viewModel.searchText, prompt: "Search for a transaction")
            .navigationTitle("Transactions")
            .toolbarSyncButton() {
                Task {
                    await viewModel.fetchExpenses()
                    await viewModel.fetchIncomes()
                }
            }
            .task {
                /// On view load, clear existing data and fetch transactions from database.
                Task {
                    viewModel.clearAllTransactions()
                    await viewModel.fetchExpenses()
                    await viewModel.fetchIncomes()
                }
            }
            .sheetPresenter(
                presentedSheet: $viewModel.presentedSheet,
                onExpenseUpdate: {
                    Task {
                        viewModel.clearAllTransactions()
                        await viewModel.fetchExpenses()
                        await viewModel.fetchIncomes()
                    }
                },
                onIncomeUpdate: {
                    Task {
                        viewModel.clearAllTransactions()
                        await viewModel.fetchExpenses()
                        await viewModel.fetchIncomes()
                    }
                },
                onExpenseCategorySelection: { selectedCategories in
                    viewModel.selectedCategories = selectedCategories
                    viewModel.selectedFilterOptions.insert(.category)
                },
                onIncomeSourceSelection: { selectedSources in
                    viewModel.selectedSources = selectedSources
                    viewModel.selectedFilterOptions.insert(.source)
                },
                onAmountRangeSelection: { selectedAmountRanges in
                    viewModel.selectedAmountRanges = selectedAmountRanges
                    viewModel.selectedFilterOptions.insert(.amount)
                },
                onDateFilterSelection: { startDate, endDate in
                    viewModel.startDate = startDate
                    viewModel.endDate = endDate
                    viewModel.selectedFilterOptions.insert(.date)
                }
            )
            .alertPresenter(
                alertType: $viewModel.alertType,
                onDeleteExpense: { expense in
                    Task { await viewModel.deleteExpense(expense) }
                },
                onDeleteIncome: { income in
                    Task { await viewModel.deleteIncome(income) }
                }
            )
        }
    }
}

#Preview {
    TransactionsView(databaseManager: .initWithInMemory)
        .environmentObject(TabManager())
        .environment(DatabaseManager.initWithInMemory)
        .environment(\.authenticator, FirebaseAuthenticator())
        .environment(NotificationManager(center: .init(), settings: NotificationSettingsHandler()))
}
