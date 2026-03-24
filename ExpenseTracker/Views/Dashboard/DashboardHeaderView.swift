import SwiftUI

/// A header view for the dashboard that displays the currently selected month-year,
/// income, expense, and total balance, and allows the user to switch between months.
///
/// - Parameters:
///   - monthYears: The list of available month-year strings to choose from.
///   - selectedMonthYear: The index of the currently selected month-year in `monthYears`.
///   - totalIncome: The total income for the selected month.
///   - totalExpense: The total expense for the selected month.
///   - balance: The calculated balance (income minus expense) for the selected month.
///   - onSelectMonth: Closure called when a new month is selected, passing its index.
///   - onMonthChanged: Async closure to handle side effects when the month selection changes (e.g., data reload).
///
/// The view displays a dropdown menu for month selection and summarizes the financial
/// totals for the selected month. The styling and currency display use the user's current locale.


//struct DashboardHeaderView: View {
//    let monthYears: [String]
//    let selectedMonthYear: Int
//    let totalIncome: Double
//    let totalExpense: Double
//    let balance: Double
//    let onSelectMonth: (Int) -> Void
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text(monthYears[selectedMonthYear])
//                    .font(.title2.bold())
//                    .padding(.vertical, 5)
//                Spacer()
//                Menu {
//                    ForEach(monthYears.indices, id: \.self) { index in
//                        Button {
//                            onSelectMonth(index)
//                        } label: {
//                            HStack {
//                                Text(monthYears[index])
//                                if selectedMonthYear == index {
//                                    Image(systemName: "checkmark")
//                                }
//                            }
//                        }
//                    }
//                } label: {
//                    Image(systemName: "chevron.up.chevron.down")
//                }
//            }
//            VStack {
//                HStack(spacing: 5) {
//                    Text("Income")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(totalIncome, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
//                        .font(.subheadline)
//                }
//                .padding(.bottom, 5)
//                HStack(spacing: 5) {
//                    Text("Expense")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(totalExpense, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
//                        .font(.subheadline)
//                        .foregroundStyle(.red1)
//                }
//            }
//            .padding(.vertical, 5)
//            HStack(spacing: 5) {
//                Text("Total Balance")
//                    .font(.title2)
//                Spacer()
//                Text("\(balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
//                    .font(.subheadline)
//                    .foregroundStyle(balance >= 0 ? .green1 : .red1)
//            }
//            .padding(.vertical, 5)
//        }
//        
//    }
//}
//
//#Preview {
//    DashboardHeaderView(
//        monthYears: ["April 2025", "May 2025"],
//        selectedMonthYear: 0,
//        totalIncome: 1000,
//        totalExpense: 500,
//        balance: 500,
//        onSelectMonth: { _ in }
//    )
//}

//struct DashboardHeaderView: View {
//    let monthYears: [String]
//    let selectedMonthYear: Int
//    let totalIncome: Double
//    let totalExpense: Double
//    let balance: Double
//    let onSelectMonth: (Int) -> Void
//    
//    var body: some View {
//        ZStack {
//            // Background gradient (more purple, less blue)
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    Color(hex: "#7D73C3"),   // Main purple
//                    Color(hex: "#9A89F2"),   // Lighter purple
//                    Color(hex: "#6A5ACD")    // Slight bluish-purple
//                ]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//            
//            VStack {
//                // Month Selector
//                HStack {
//                    Text(monthYears[selectedMonthYear])
//                        .font(.title2.bold())
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                    
//                    Menu {
//                        ForEach(monthYears.indices, id: \.self) { index in
//                            Button {
//                                onSelectMonth(index)
//                            } label: {
//                                HStack {
//                                    Text(monthYears[index])
//                                    if selectedMonthYear == index {
//                                        Image(systemName: "checkmark")
//                                    }
//                                }
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "chevron.up.chevron.down")
//                            .foregroundColor(.white)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 10)
//                
//                Spacer()
//                
//                // Total Balance Centered
//                VStack(spacing: 5) {
//                    Text("Total Balance")
//                        .font(.headline.bold())
//                        .foregroundColor(.white)
//                    
//                    Text("\(balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
//                        .font(.system(size: 28, weight: .bold))
//                        .foregroundColor(.white)
//                }
//                
//                Spacer()
//                
//                // Income & Expense at Bottom
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("Income")
//                            .font(.headline)
//                            .foregroundColor(.white.opacity(0.9))
//                        Text("\(totalIncome, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
//                            .font(.subheadline.bold())
//                            .foregroundColor(.green)
//                    }
//                    
//                    Spacer()
//                    
//                    VStack(alignment: .trailing) {
//                        Text("Expense")
//                            .font(.headline)
//                            .foregroundColor(.white.opacity(0.9))
//                        Text("\(totalExpense, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
//                            .font(.subheadline.bold())
//                            .foregroundColor(.red)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 15)
//            }
//        }
//        .frame(height: 220) // Set header height
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .shadow(radius: 5)
//    }
//}
//
//// MARK: - HEX Color Extension
//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        _ = scanner.scanString("#")
//        
//        var rgb: UInt64 = 0
//        scanner.scanHexInt64(&rgb)
//        
//        let r = Double((rgb >> 16) & 0xFF) / 255
//        let g = Double((rgb >> 8) & 0xFF) / 255
//        let b = Double(rgb & 0xFF) / 255
//        
//        self.init(red: r, green: g, blue: b)
//    }
//}
//
//#Preview {
//    DashboardHeaderView(
//        monthYears: ["April 2025", "May 2025"],
//        selectedMonthYear: 0,
//        totalIncome: 2350,
//        totalExpense: 950,
//        balance: 2350 - 950,
//        onSelectMonth: { _ in }
//    )
//}

//[Color(hex: "#3E63D5"), Color(hex: "#484CB8"), Color(hex: "#474BB9")]
struct DashboardHeaderView: View {
    let monthYears: [String]
    let selectedMonthYear: Int
    let totalIncome: Double
    let totalExpense: Double
    let balance: Double
    let onSelectMonth: (Int) -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#F58374"), Color(hex: "#C65B93"), Color(hex: "#A5509D")]
                                  ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Month Selector
                HStack {
                    Text(monthYears[selectedMonthYear])
                        .font(AppFont.poppins(.medium, size: 25))
                        .foregroundColor(.white)
                    
                    //Spacer()
                    
                    Menu {
                        ForEach(monthYears.indices, id: \.self) { index in
                            Button {
                                onSelectMonth(index)
                            } label: {
                                HStack {
                                    Text(monthYears[index])
                                    if selectedMonthYear == index {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                // Total Balance Centered
                VStack(spacing: 5) {
                    Text("Total Balance")
                        .font(AppFont.poppins(.medium, size: 16))
                        .foregroundColor(.white)
                    
                    Text("\(balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                        .font(AppFont.poppins(.medium, size: 30))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Income & Expense at Bottom (with icons)
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.white.opacity(0.3))
                            .imageScale(.large)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Income")
                                .font(AppFont.poppins(.medium, size: 16))
                                .foregroundColor(.white.opacity(0.9))
                            Text("\(totalIncome, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.white.opacity(0.5))
                            .imageScale(.large)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Expense")
                                .font(AppFont.poppins(.medium, size: 16))
                                .foregroundColor(.white.opacity(0.9))
                            Text("\(totalExpense, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 5)
            }
        }
        .frame(height: 220) // Set header height
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}

// MARK: - HEX Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    DashboardHeaderView(
        monthYears: ["April 2025", "May 2025"],
        selectedMonthYear: 0,
        totalIncome: 2350,
        totalExpense: 950,
        balance: 2350 - 950,
        onSelectMonth: { _ in }
    )
}
