//
//  MultipleSelectionView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 03/04/25.
//

import SwiftUI
/// A generic model representing a selectable item with a title and an associated value.
struct MultipleSelectionItem<T: Hashable>: Hashable {
    /// The display title for the item.
    let title: String
    
    /// The actual item of generic type `T`.
    let item: T
    
    /// Optional icon for the item
    let icon: String?
    
    /// Optional description for the item
    let description: String?
    
    init(title: String, item: T, icon: String? = nil, description: String? = nil) {
        self.title = title
        self.item = item
        self.icon = icon
        self.description = description
    }
}

/// A modern, animated SwiftUI view for selecting multiple items from a list.
struct MultipleSelectionView<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    /// Stores the currently selected items.
    @State private var selectedItems: Set<MultipleSelectionItem<T>> = []
    
    /// Animation state for smooth transitions
    @State private var animateSelection = false
    
    /// The list of available items to display.
    let items: [MultipleSelectionItem<T>]
    
    /// The title to display in the navigation bar.
    let title: String
    
    /// The subtitle/description for the view
    let subtitle: String?
    
    /// Closure called when the user finishes selection, returning selected items of type `T`.
    let onSelection: ([T]) -> Void
    
    /// Custom gradient colors
    private let gradientColors = [
        Color(hex: "#F58374"),
        Color(hex: "#C65B93"),
        Color(hex: "#A5509D")
    ]
    
    /// Initializes the multiple selection view.
    /// - Parameters:
    ///   - items: The list of items to choose from.
    ///   - title: The title shown at the top of the screen.
    ///   - subtitle: Optional subtitle for additional context.
    ///   - onSelection: A closure that returns the final selection.
    init(items: [MultipleSelectionItem<T>], title: String, subtitle: String? = nil, onSelection: @escaping ([T]) -> Void) {
        self.items = items
        self.title = title
        self.subtitle = subtitle
        self.onSelection = onSelection
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    selectionListSection
                    actionButtonsSection
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Select one or more items")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        dismiss()
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Selection counter
            if !selectedItems.isEmpty {
                HStack {
                    Text("\(selectedItems.count) item\(selectedItems.count == 1 ? "" : "s") selected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                                .opacity(0.1)
                        )
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            Divider()
                .padding(.top, 8)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Selection List Section
    private var selectionListSection: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(Array(items.enumerated()), id: \.element) { index, item in
                    MultipleSelectionRow(
                        item: item,
                        isSelected: selectedItems.contains(item),
                        gradientColors: gradientColors,
                        animationDelay: Double(index) * 0.05
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            toggleSelection(of: item)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 16) {
                // Clear Button
                Button("Clear All") {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        selectedItems.removeAll()
                    }
                }
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .disabled(selectedItems.isEmpty)
                .opacity(selectedItems.isEmpty ? 0.6 : 1.0)
                
                // Apply Button
                Button("Apply Selection") {
                    onSelection(selectedItems.map { $0.item })
                    withAnimation(.easeInOut(duration: 0.3)) {
                        dismiss()
                    }
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    selectedItems.isEmpty
                    ? LinearGradient(colors: [Color.gray.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .disabled(selectedItems.isEmpty)
                .scaleEffect(selectedItems.isEmpty ? 0.95 : 1.0)
                .shadow(
                    color: selectedItems.isEmpty ? .clear : gradientColors.first?.opacity(0.3) ?? .clear,
                    radius: selectedItems.isEmpty ? 0 : 8,
                    x: 0, y: 4
                )
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedItems.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }
    
    /// Toggles the selection state of an item.
    /// - Parameter item: The item to toggle in the selection set.
    private func toggleSelection(of item: MultipleSelectionItem<T>) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}

/// A modern row view representing a selectable item with smooth animations.
struct MultipleSelectionRow<T: Hashable>: View {
    /// The selection item containing title and data
    let item: MultipleSelectionItem<T>
    
    /// Whether the row is currently selected.
    let isSelected: Bool
    
    /// Custom gradient colors
    let gradientColors: [Color]
    
    /// Animation delay for staggered entrance
    let animationDelay: Double
    
    /// Action to perform when the row is tapped.
    let action: () -> Void
    
    @State private var hasAppeared = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Selection indicator with gradient
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ?
                              LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing) :
                              LinearGradient(colors: [Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isSelected ? Color.clear : Color(.systemGray4), lineWidth: 1)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(isSelected ? 1.0 : 0.5)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                    }
                }
                
                // Icon if provided
                if let icon = item.icon {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? gradientColors.first : .secondary)
                        .frame(width: 24, height: 24)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let description = item.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // Subtle arrow indicator
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(0.6)
                    .rotationEffect(.degrees(isSelected ? 90 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(.systemGray6) : Color(.systemBackground))
                    .stroke(
                        isSelected ?
                        LinearGradient(colors: gradientColors.map { $0.opacity(0.3) }, startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [Color(.systemGray4)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.02 : hasAppeared ? 1.0 : 0.9)
            .opacity(hasAppeared ? 1.0 : 0.0)
            .shadow(
                color: isSelected ? (gradientColors.first?.opacity(0.15) ?? .clear) : .clear,
                radius: isSelected ? 8 : 0,
                x: 0, y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(animationDelay)) {
                hasAppeared = true
            }
        }
    }
}

#Preview {
    MultipleSelectionView(
        items: [
            MultipleSelectionItem(title: "Food & Dining", item: "food", icon: "fork.knife", description: "Restaurants, groceries, and takeout"),
            MultipleSelectionItem(title: "Transportation", item: "transport", icon: "car", description: "Gas, parking, and public transit"),
            MultipleSelectionItem(title: "Entertainment", item: "entertainment", icon: "tv", description: "Movies, games, and subscriptions"),
            MultipleSelectionItem(title: "Shopping", item: "shopping", icon: "bag", description: "Clothes, electronics, and misc items"),
            MultipleSelectionItem(title: "Healthcare", item: "health", icon: "cross.case", description: "Medical expenses and insurance")
        ],
        title: "Expense Categories",
        subtitle: "Choose the categories you want to filter by"
    ) { _ in }
}
