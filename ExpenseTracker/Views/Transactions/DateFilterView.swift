////
////  DateFilterView.swift
////  ExpenseTracker
////
////  Created by Pankaj Rana on 07/04/25.
////
//
//import SwiftUI
//
///// A view that allows the user to select a date filter range (e.g., last 30/60/90 days or custom).
//struct DateFilterView: View {
//    
//    /// Enum representing the available date filter options.
//    enum DateFilterOption: String, CaseIterable, Identifiable {
//        case last30Days = "Last 30 Days"
//        case last60Days = "Last 60 Days"
//        case last90Days = "Last 90 Days"
//        case customRange = "Custom Range"
//        
//        var id: String { rawValue }
//    }
//
//    /// Used to dismiss the current view (in a sheet or navigation stack).
//    @Environment(\.dismiss) var dismiss
//    
//    /// The currently selected date filter option.
//    @State private var selectedOption: DateFilterOption?
//    
//    /// Start date for the custom range (defaulted to 7 days ago).
//    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
//    
//    /// End date for the custom range (defaulted to today).
//    @State private var endDate: Date = Date()
//    
//    /// Callback triggered when a valid date range is applied.
//    var onSelectDateRange: ((Date, Date) -> Void)
//
//    /// Computes the final selected date range based on the selected option.
//    private var selectedDateRange: (startDate: Date, endDate: Date)? {
//        guard let selectedOption else {
//            return nil
//        }
//        let now = Date()
//        switch selectedOption {
//        case .last30Days:
//            return (Calendar.current.date(byAdding: .day, value: -30, to: now)!, now)
//        case .last60Days:
//            return (Calendar.current.date(byAdding: .day, value: -60, to: now)!, now)
//        case .last90Days:
//            return (Calendar.current.date(byAdding: .day, value: -90, to: now)!, now)
//        case .customRange:
//            return (startDate, endDate)
//        }
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                
//                // Header with title and dismiss button
//                HStack {
//                    Text("Date")
//                    Spacer()
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                }
//                .padding(20)
//                
//                // Display all available date filter options
//                ForEach(DateFilterOption.allCases) { option in
//                    Button(action: {
//                        selectedOption = option
//                    }) {
//                        HStack {
//                            Text(option.rawValue)
//                            Spacer()
//                                Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
//                                .foregroundColor(selectedOption == option ? .green1 : .gray)
//                        }
//                        .padding(20)
//                        .background(selectedOption == option ? Color.gray.opacity(0.2) : Color.clear)
//                        .listRowInsets(EdgeInsets())
//                    }
//                    .tint(Color.primary)
//                }
//                
//                // Show date pickers when custom range is selected
//                if selectedOption == .customRange {
//                    VStack(alignment: .leading, spacing: 15) {
//                        HStack {
//                            Text("Start Date")
//                            Spacer()
//                            DatePicker("Start Date", selection: $startDate, in: ...endDate, displayedComponents: [.date])
//                            .labelsHidden()
//                        }
//                        HStack {
//                            Text("End Date")
//                            Spacer()
//                            DatePicker("End Date", selection: $endDate, in: startDate...Date(), displayedComponents: [.date])
//                                .labelsHidden()
//                        }
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                }
//                
//                // Buttons to clear or apply the selection
//                HStack(spacing: 20) {
//                    Spacer()
//                    Button("Clear") {
//                        selectedOption = nil
//                    }
//                    Button("Apply") {
//                        if let selectedDateRange {
//                            var calendar = Calendar.current
//                            calendar.timeZone = .gmt
//                            onSelectDateRange(calendar.startOfDay(for: selectedDateRange.startDate), calendar.startOfDay(for: selectedDateRange.endDate))
//                        }
//                        dismiss()
//                    }
//                    .disabled(selectedOption == nil)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 20)
//                    .background(selectedOption == nil ? .gray.opacity(0.5) : .green1.opacity(0.3))
//                    .clipShape(.capsule)
//                    .foregroundStyle(.primary)
//                }
//                .padding()
//
//                Spacer()
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    DateFilterView() { _, _ in }
//}


import SwiftUI

/// A modern, animated view that allows the user to select a date filter range.
struct DateFilterView: View {
    
    /// Enum representing the available date filter options.
    enum DateFilterOption: String, CaseIterable, Identifiable {
        case last30Days = "Last 30 Days"
        case last60Days = "Last 60 Days"
        case last90Days = "Last 90 Days"
        case customRange = "Custom Range"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .last30Days: return "calendar.badge.clock"
            case .last60Days: return "calendar.badge.clock"
            case .last90Days: return "calendar.badge.clock"
            case .customRange: return "calendar.badge.plus"
            }
        }
        
        var description: String {
            switch self {
            case .last30Days: return "View expenses from the past month"
            case .last60Days: return "View expenses from the past 2 months"
            case .last90Days: return "View expenses from the past 3 months"
            case .customRange: return "Choose your own date range"
            }
        }
    }

    /// Used to dismiss the current view (in a sheet or navigation stack).
    @Environment(\.dismiss) var dismiss
    
    /// The currently selected date filter option.
    @State private var selectedOption: DateFilterOption?
    
    /// Start date for the custom range (defaulted to 7 days ago).
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    
    /// End date for the custom range (defaulted to today).
    @State private var endDate: Date = Date()
    
    /// Animation state for smooth transitions
    @State private var showCustomPickers = false
    
    /// Callback triggered when a valid date range is applied.
    var onSelectDateRange: ((Date, Date) -> Void)

    /// Computes the final selected date range based on the selected option.
    private var selectedDateRange: (startDate: Date, endDate: Date)? {
        guard let selectedOption else {
            return nil
        }
        let now = Date()
        switch selectedOption {
        case .last30Days:
            return (Calendar.current.date(byAdding: .day, value: -30, to: now)!, now)
        case .last60Days:
            return (Calendar.current.date(byAdding: .day, value: -60, to: now)!, now)
        case .last90Days:
            return (Calendar.current.date(byAdding: .day, value: -90, to: now)!, now)
        case .customRange:
            return (startDate, endDate)
        }
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        filterOptionsSection
                        customRangeSection
                        actionButtonsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Filter by Date")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Choose a date range to filter your expenses")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
            
            Divider()
                .padding(.top, 8)
        }
    }
    
    // MARK: - Filter Options Section
    private var filterOptionsSection: some View {
        LazyVStack(spacing: 12) {
            ForEach(DateFilterOption.allCases) { option in
                filterOptionRow(option)
            }
        }
    }
    
    private func filterOptionRow(_ option: DateFilterOption) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                if selectedOption == option {
                    selectedOption = nil
                    showCustomPickers = false
                } else {
                    selectedOption = option
                    showCustomPickers = option == .customRange
                }
            }
        }) {
            HStack(spacing: 16) {
                // Icon with background
                Image(systemName: option.icon)
                    .font(.title3)
                    .foregroundColor(selectedOption == option ? .white : .primary)
                    .frame(width: 44, height: 44)
                    .background(
                        selectedOption == option
                        ? AnyView(LinearGradient(colors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        : AnyView(Color(.systemGray5))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(option.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(option.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Selection indicator with animation
                Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(selectedOption == option ? .green : .secondary)
                    .scaleEffect(selectedOption == option ? 1.1 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedOption)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedOption == option ? Color(.systemGray6) : Color(.systemBackground))
                    .stroke(
                        selectedOption == option ?
                        LinearGradient(colors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [Color(.systemGray4)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: selectedOption == option ? 1.5 : 1
                    )
            )
            .scaleEffect(selectedOption == option ? 1.02 : 1.0)
            .shadow(
                color: selectedOption == option ? .blue.opacity(0.1) : .clear,
                radius: selectedOption == option ? 8 : 0,
                x: 0, y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedOption)
    }
    
    // MARK: - Custom Range Section
    private var customRangeSection: some View {
        Group {
            if showCustomPickers {
                VStack(spacing: 16) {
                    datePickerRow(title: "Start Date", date: $startDate, range: ...endDate)
                    datePickerRow(title: "End Date", date: $endDate, range: startDate...Date())
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .stroke(LinearGradient(colors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
    }
    
    private func datePickerRow(title: String, date: Binding<Date>, range: PartialRangeThrough<Date>) -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            DatePicker("", selection: date, in: range, displayedComponents: [.date])
                .labelsHidden()
                .scaleEffect(0.9)
        }
    }
    
    private func datePickerRow(title: String, date: Binding<Date>, range: ClosedRange<Date>) -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            DatePicker("", selection: date, in: range, displayedComponents: [.date])
                .labelsHidden()
                .scaleEffect(0.9)
        }
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            // Clear Button
            Button("Clear") {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    selectedOption = nil
                    showCustomPickers = false
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
            
            // Apply Button
            Button("Apply Filter") {
                if let selectedDateRange {
                    var calendar = Calendar.current
                    calendar.timeZone = .gmt
                    onSelectDateRange(calendar.startOfDay(for: selectedDateRange.startDate), calendar.startOfDay(for: selectedDateRange.endDate))
                }
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
                selectedOption == nil
                ? AnyView(Color.gray.opacity(0.6))
                : AnyView(LinearGradient(colors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")], startPoint: .leading, endPoint: .trailing))
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .disabled(selectedOption == nil)
            .scaleEffect(selectedOption == nil ? 0.95 : 1.0)
            .shadow(
                color: selectedOption == nil ? .clear : .blue.opacity(0.3),
                radius: selectedOption == nil ? 0 : 8,
                x: 0, y: 4
            )
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedOption)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    DateFilterView() { _, _ in }
}
