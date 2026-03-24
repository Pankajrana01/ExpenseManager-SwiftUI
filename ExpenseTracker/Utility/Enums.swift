//
//  Enums.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 02/04/25.
//

import Foundation

/// Represents the available options for sorting data (such as expenses or incomes)
/// in the expense tracker application.
///
/// Each case corresponds to a different attribute by which the user can sort entries.
/// These sorting preferences help users organize their financial records based on relevance.
enum SortingOption: String, CaseIterable {
    
    /// Sort by the date of the transaction.
    ///
    /// - Use Case: Display transactions in chronological or reverse-chronological order.
    /// - Often used in reports, history views, or trends over time.
    case date = "Date"
    
    /// Sort by the monetary amount of the transaction.
    ///
    /// - Use Case: Prioritize large or small transactions.
    /// - Useful for identifying high-spend categories or filtering by impact.
    case amount = "Amount"
    
    /// Sort alphabetically by the name or title associated with the transaction.
    ///
    /// - Use Case: Helpful in quickly locating a specific entry or grouping similar entries (e.g., merchant names, categories).
    case name = "Name"
    
    /// A computed property that provides an appropriate SF Symbol system image name for each sort option.
    ///
    /// These icons can be used alongside text labels in the UI to provide a more intuitive and visually
    /// engaging interface, such as in segmented controls or filter dropdowns.
    var systemImageName: String {
        switch self {
        case .date:
            return "calendar"
        case .amount:
            return "dollarsign"
        case .name:
            return "a.circle.fill"
        }
    }
}

/// An enumeration representing the direction of sorting used in various parts of the expense tracker app.
///
/// `Ordering` is used in sorting lists such as transactions, incomes, or expenses based on selected criteria
/// (e.g., date or amount). This improves data visualization and enhances user control over list organization.
enum Ordering {
    
    /// Ascending order.
    ///
    /// - For dates: earlier dates appear first (e.g., Jan → Dec).
    /// - For numbers: lower values appear first (e.g., 100 → 1000).
    /// - Typical use cases: chronological views, trend analysis, budgeting over time.
    case ascending
    
    /// Descending order.
    ///
    /// - For dates: later dates appear first (e.g., Dec → Jan).
    /// - For numbers: higher values appear first (e.g., 1000 → 100).
    /// - Typical use cases: seeing most recent transactions or highest expenses first.
    case descending
    
    /// A computed property that provides an appropriate SF Symbol system image name for each ordering option.
    ///
    /// These icons can be used alongside text labels in the UI to provide a more intuitive and visually
    /// engaging interface, such as in segmented controls or filter dropdowns.
    var systemImageName: String {
        switch self {
        case .ascending:
            return "arrowtriangle.up.fill"
        case .descending:
            return "arrowtriangle.down.fill"
        }
    }
}

protocol Displayable {
    var displayName: String { get }
}

/// An enumeration representing the different sources of income in the expense tracker application.
///
/// Categorizing income sources helps users track where their money is coming from,
/// providing better visibility and reporting for budgeting or financial analysis.
///
/// This enum conforms to:
/// - `String`: Each case has a user-friendly raw string value for display and persistence.
/// - `CaseIterable`: Enables looping over all values (e.g., for UI pickers or filters).
/// - `Codable`: Supports encoding/decoding when saving or loading data from a database or API.
enum Source: String, CaseIterable, Codable {
    
    /// Income from full-time, part-time, or contractual employment.
    /// Examples: monthly salary, bonuses, or wages.
    case salary = "Salary"
    
    /// Income generated from interest-bearing accounts or investments.
    /// Examples: fixed deposits, savings accounts, or bonds.
    case interest = "Interest"
    
    /// Income earned from renting out property or assets.
    /// Examples: rental properties, equipment leasing, or subletting.
    case rental = "Rental"
    
    /// Income generated through business activities or self-employment.
    /// Examples: freelancing, entrepreneurship, consulting, or side hustles.
    case business = "Business"
    
    /// Any other type of income not classified above.
    /// Examples: gifts, lottery winnings, inheritance, or one-time gains.
    case other = "Other"
}

extension Source: Displayable {
    var displayName: String { self.rawValue }
}

extension Source {
    var iconName: String {
        switch self {
        case .salary:
            return "briefcase.fill"
        case .interest:
            return "banknote.fill"
        case .rental:
            return "building.columns.fill"
        case .business:
            return "person.2.wave.2.fill"
        case .other:
            return "gift.fill"
        }
    }
}

/// Represents the different categories of income or expense used in budgeting and financial tracking.
///
/// This enum is `CaseIterable`, allowing easy iteration over all available cases (e.g., for use in dropdown menus or pickers),
/// and conforms to `Codable`, enabling seamless encoding and decoding to/from JSON or other formats.
///
/// Each case maps to a user-friendly string value, suitable for display in UI elements.
///
/// You can use `Category` to tag transactions, filter data, or group items for insights.
///
/// Example usage:
/// ```swift
/// let category: Category = .food
/// print(category.rawValue) // Output: "Food & Groceries"
/// ```
///
/// You can also get all categories for selection:
/// ```swift
/// let allCategories = Category.allCases
/// ```
enum Category: String, CaseIterable, Codable, Displayable {
    
    /// Expenses related to rent, mortgage, utilities, or property maintenance.
    case household = "Household"
    
    /// Spending on groceries, restaurants, cafes, and other food-related purchases.
    case food = "Food"
    
    /// Costs associated with leisure activities like movies, vacations,
    /// subscriptions (e.g., Netflix), events, or hobbies.
    case entertainment = "Entertainment"
    
    /// Expenses for transportation, trips, commuting.
    case travel = "Travel"
    
    /// Purchases of goods like clothes, electronics, or personal items.
    case shopping = "Shopping"
    
    /// Costs associated with medical care, insurance, pharmacy, and wellness, gym memberships.
    case health = "Health"
    
    /// Personal care, grooming, self-improvement, and miscellaneous personal spending.
    case personal = "Personal"
    
    /// Expenses related to family, children, dependents, or shared household needs.
    case family = "Family"
    
    /// Tuition fees, books, courses, training, and all educational expenses.
    case education = "Education"
    
    /// Banking, interest, debt payments, loan EMIs, or insurance.
    case finance = "Finance"
    
    /// Money allocated or spent on stocks, mutual funds, crypto, or other assets.
    case investment = "Investment"
    
    /// Recurring expenses like Spotify, iCloud, or Google Drive.
    case subscription = "Subscription"
    
    /// Any transaction that doesn't fit into the predefined categories.
    case other = "Other"
    
    var displayName: String {
        switch self {
        case .household:
            "Household"
        case .food:
            "Food and Groceries"
        case .entertainment:
            "Entertainment"
        case .travel:
            "Transportation"
        case .shopping:
            "Shopping"
        case .health:
            "Health & Medical"
        case .personal:
            "Personal"
        case .family:
            "Family"
        case .education:
            "Education"
        case .finance:
            "Finance"
        case .investment:
            "Investment"
        case .subscription:
            "Subscription"
        case .other:
            "Other"
        }
    }
    
    var description: String {
        switch self {
        case .household:
            return "Covers all costs related to your residence, including rent, mortgage, utilities (electricity, gas, water), maintenance, and property taxes."

        case .food:
            return "Includes all food-related expenses such as groceries, dining out, takeout, cafes, and bakeries."

        case .entertainment:
            return "Captures leisure spending like movies, streaming services, concerts, books, games, hobbies, and events."

        case .travel:
            return "Covers transportation and travel costs including flights, hotels, fuel, taxis or rideshares, tolls, and vacations."

        case .shopping:
            return "Non-essential purchases like clothing, electronics, gadgets, cosmetics, accessories, home décor, and gifts."

        case .health:
            return "Medical and wellness expenses including doctor visits, medications, insurance, therapy, dental care, and fitness memberships."

        case .personal:
            return "Self-care and personal growth expenses such as grooming, spa visits, journaling apps, and online learning platforms."

        case .family:
            return "Shared family costs like groceries, childcare, elder care, school fees, family gifts, and outings."

        case .education:
            return "Learning-related expenses such as tuition, courses, books, certifications, and study materials."

        case .investment:
            return "Funds invested in assets like stocks, crypto, mutual funds, property, or retirement and savings accounts."

        case .finance:
            return "Financial obligations or services including loans, interest payments, banking fees, and money transfers."

        case .subscription:
            return "Recurring service fees for apps, software, music, news, or productivity tools."

        case .other:
            return "Miscellaneous or uncategorized expenses that don’t fit into the other categories."
        }
    }

}

extension Category {
    var iconName: String {
        switch self {
        case .household: return "house.fill"
        case .food: return "takeoutbag.and.cup.and.straw.fill"
        case .entertainment: return "film.fill"
        case .travel: return "airplane"
        case .shopping: return "bag.fill"
        case .health: return "cross.case.fill"
        case .personal: return "person.fill"
        case .family: return "person.2.fill"
        case .education: return "book.fill"
        case .investment: return "chart.bar.xaxis"
        case .finance: return "creditcard.fill"
        case .subscription: return "repeat"
        case .other: return "ellipsis"
        }
    }
}

/// An enumeration representing various filter options available for organizing or narrowing down transactions
/// in the expense tracker application. Each case corresponds to a distinct criterion by which the user can
/// filter their data, such as by date, amount, income source, or expense category.
///
/// This enum conforms to `RawRepresentable` (via `String`) for display purposes,
/// and `CaseIterable` to allow easy iteration over all possible filter types—for example, in UI menus or pickers.
enum FilterOption: String, CaseIterable {
    
    /// Filters transactions based on their associated date.
    ///
    /// This allows users to view entries from a specific day, month, or year,
    /// and is useful when reviewing daily, monthly, or yearly income and expenses.
    case date = "Date"
    
    /// Filters transactions based on the monetary value of the transaction.
    ///
    /// This is useful when analyzing high or low-value transactions, or
    /// comparing spending vs earnings by amount.
    case amount = "Amount"
    
    /// Filters income entries by their source, such as salary, business, or rental income.
    ///
    /// This helps users understand which income streams contribute most to their earnings.
    case source = "Income Source"
    
    /// Filters expenses by their category, such as food, travel, or utilities.
    ///
    /// Useful for budgeting and analyzing where the user spends the most money.
    case category = "Expense Category"
}

enum AmountRange: CaseIterable {
    case lessThanTwoHundred
    case twoHundredToFiveHundred
    case fiveHundredToTwoThousand
    case moreThanTwoThousand
    
    var title: String {
        switch self {
        case .lessThanTwoHundred:
            return "Up to \(Locale.current.currencySymbol ?? "$")200"
        case .twoHundredToFiveHundred:
            return "\(Locale.current.currencySymbol ?? "$")200 - \(Locale.current.currencySymbol ?? "$")500"
        case .fiveHundredToTwoThousand:
            return "\(Locale.current.currencySymbol ?? "$")500 - \(Locale.current.currencySymbol ?? "$")2000"
        case .moreThanTwoThousand:
            return "Above \(Locale.current.currencySymbol ?? "$")2000"
        }
    }
    
    var range: ClosedRange<Double> {
        switch self {
        case .lessThanTwoHundred:
            return 0.0...200.0
        case .twoHundredToFiveHundred:
            return 200.0...500.0
        case .fiveHundredToTwoThousand:
            return 500.0...2000.0
        case .moreThanTwoThousand:
            return 2000.0...9999999.0
        }
    }
}

/// Represents the available types of databases the app can switch between.
enum DatabaseType {
    case inMemory
    case local
    case firebase(String) // Associated value holds the user ID
    
    /// Human-readable description of the database type
    var description: String {
        switch self {
        case .inMemory:
            return "InMemory"
        case .local:
            return "Local"
        case let .firebase(userId):
            return "Firebase-\(userId)"
        }
    }
}

/// A namespace for keys used to store data persistently in UserDefaults.
/// These keys act as identifiers for accessing serialized data blobs.
enum UserDefaultsDataSourceKey {
    /// Key used for storing and retrieving expense records.
    static var expenses = "Expenses"
    
    /// Key used for storing and retrieving income records.
    static var incomes = "Incomes"
    
    /// Key used for storing and retrieving user-specific profile or account information.
    static var userDetails = "UserDetails"
}
