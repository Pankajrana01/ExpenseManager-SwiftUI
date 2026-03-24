//
//  TabManager.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 05/04/25.
//

import Combine

/// A simple class that manages the state of the currently selected tab in a tab-based UI.
///
/// This class conforms to `ObservableObject`, allowing SwiftUI views to automatically
/// update when the selected tab index changes.
class TabManager: ObservableObject {
    
    /// The index of the currently selected tab.
    ///
    /// Use this property to track and update the active tab in your UI.
    /// For example, 0 could represent the "Dashboard" tab, 1 for "Insights", and so on.
    @Published var selectedTabIndex: Int = 0
}
