//
//  SheetPresenterModifier.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 04/06/25.
//

import SwiftUI

enum PresentedSheet: Identifiable {
    case addExpense(DatabaseManager)
    case addIncome(DatabaseManager)
    case editExpense(DatabaseManager, Expense)
    case editIncome(DatabaseManager, Income)
    case showExpenseCategory
    case showIncomeSource
    case showAmountRange
    case showDateFilter
    
    var id: String {
        switch self {
        case .addExpense:
            "addExpense"
        case .addIncome:
            "addIncome"
        case .editExpense:
            "editExpense"
        case .editIncome:
            "editIncome"
        case .showExpenseCategory:
            "showExpenseCategory"
        case .showIncomeSource:
            "showIncomeSource"
        case .showAmountRange:
            "showAmountRange"
        case .showDateFilter:
            "showDateFilter"
        }
    }
}

struct SheetPresenterModifier: ViewModifier {
    @Binding var presentedSheet: PresentedSheet?
    let onExpenseAdd: (() -> Void)?
    let onIncomeAdd: (() -> Void)?
    let onExpenseUpdate: (() -> Void)?
    let onIncomeUpdate: (() -> Void)?
    let onExpenseCategorySelection: (([Category]) -> Void)?
    let onIncomeSourceSelection: (([Source]) -> Void)?
    let onAmountRangeSelection: (([AmountRange]) -> Void)?
    let onDateFilterSelection: ((Date, Date) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $presentedSheet) { sheet in
                switch sheet {
                case let .addExpense(databaseManager):
                    AddExpenseView(databaseManager: databaseManager) {
                        if let onExpenseAdd { onExpenseAdd() }
                    }
                case let .addIncome(databaseManager):
                    AddIncomeView(databaseManager: databaseManager) {
                        if let onIncomeAdd { onIncomeAdd() }
                    }
                case let .editExpense(databaseManager, expense):
                    EditExpenseView(
                        expense: expense,
                        databaseManager: databaseManager
                    ) {
                        if let onExpenseUpdate { onExpenseUpdate() }
                    }
                case let .editIncome(databaseManager, income):
                    EditIncomeView(
                        income: income,
                        databaseManager: databaseManager
                    ) {
                        if let onIncomeUpdate { onIncomeUpdate() }
                    }
                case .showExpenseCategory:
                    MultipleSelectionView(
                        items: Category.allCases.map{
                            MultipleSelectionItem(title: $0.rawValue, item: $0)
                        },
                        title: "Expense Category"
                    ) { selectedCategories in
                        if let onExpenseCategorySelection { onExpenseCategorySelection(selectedCategories) }
                    }
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
                case .showIncomeSource:
                    MultipleSelectionView(items: Source.allCases.map{ MultipleSelectionItem(title: $0.rawValue, item: $0) }, title: "Income Source") { selectedSources in
                        if let onIncomeSourceSelection { onIncomeSourceSelection(selectedSources) }
                    }
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
                case .showAmountRange:
                    MultipleSelectionView(items: AmountRange.allCases.map{ MultipleSelectionItem(title: $0.title, item: $0) }, title: "Amount") { selectedAmountRanges in
                        if let onAmountRangeSelection { onAmountRangeSelection(selectedAmountRanges) }
                    }
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
                case .showDateFilter:
                    DateFilterView() { startDate, endDate in
                        if let onDateFilterSelection { onDateFilterSelection(startDate, endDate) }
                    }
                }
            }
    }
}

extension View {
    func sheetPresenter(
        presentedSheet: Binding<PresentedSheet?>,
        onExpenseAdd: (() -> Void)? = nil,
        onIncomeAdd: (() -> Void)? = nil,
        onExpenseUpdate: (() -> Void)? = nil,
        onIncomeUpdate: (() -> Void)? = nil,
        onExpenseCategorySelection: (([Category]) -> Void)? = nil,
        onIncomeSourceSelection: (([Source]) -> Void)? = nil,
        onAmountRangeSelection: (([AmountRange]) -> Void)? = nil,
        onDateFilterSelection: ((Date, Date) -> Void)? = nil
    ) -> some View {
        self.modifier(
            SheetPresenterModifier(
                presentedSheet: presentedSheet,
                onExpenseAdd: onExpenseAdd,
                onIncomeAdd: onIncomeAdd,
                onExpenseUpdate: onExpenseUpdate,
                onIncomeUpdate: onIncomeUpdate,
                onExpenseCategorySelection: onExpenseCategorySelection,
                onIncomeSourceSelection: onIncomeSourceSelection,
                onAmountRangeSelection: onAmountRangeSelection,
                onDateFilterSelection: onDateFilterSelection
            )
        )
    }
}
