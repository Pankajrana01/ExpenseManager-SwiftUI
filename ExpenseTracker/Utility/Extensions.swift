//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 01/04/25.
//

import Foundation
import UIKit

/// A constant for the default date format used for formatting and parsing dates.
/// The default format is "yyyy-MM-dd".
let DATE_FORMAT: String = "yyyy-MM-dd"

/// An extension for the `Date` type that adds functionality for formatting a `Date` object into a `String`.
extension Date {
    
    /// Converts a `Date` object to a formatted string.
    ///
    /// - Parameter dateFormat: A custom date format string (default is "yyyy-MM-dd").
    /// - Returns: A string representation of the `Date` object formatted according to the specified format.
    func formattedString(dateFormat: String = DATE_FORMAT) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    /// Returns a new `Date` by adding a specified value to a calendar component of the current date.
    ///
    /// This method uses the current calendar (`Calendar.current`) to compute the new date.
    /// It's useful for adding or subtracting date components like days, months, or years.
    ///
    /// - Parameters:
    ///   - component: The `Calendar.Component` (e.g., `.day`, `.month`, `.year`) to modify.
    ///   - value: The amount to add (positive or negative).
    /// - Returns: A new `Date` object adjusted by the specified amount.
    ///
    /// - Note: This method force unwraps the result and will crash if `Calendar` fails to compute the new date.
    func byAdding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
}


/// An extension for the `String` type that adds functionality for parsing a `String` into a `Date` object.
extension String {
    
    /// Converts a `String` representation of a date to a `Date` object.
    ///
    /// - Parameter dateFormat: A custom date format string (default is "yyyy-MM-dd").
    /// - Returns: A `Date` object corresponding to the string representation.
    /// - Note: If the string cannot be parsed into a valid `Date` object, this will crash.
    func toDate(dateFormat: String = DATE_FORMAT) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.gmt
        return dateFormatter.date(from: self)!
    }
}


/// An extension for the `Collection` type that adds a computed property to check if a collection is not empty.
extension Collection {
    
    /// A Boolean value that indicates whether the collection is not empty.
    ///
    /// - Returns: `true` if the collection contains at least one element; `false` otherwise.
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension Bundle {
    
    /// Retrieves the Clerk publishable key from the app's Info.plist.
    ///
    /// - Returns: The value of `CLERK_PUBLISHABLE_KEY` from the Info.plist.
    /// - Note: This key should be defined in your `Secrets.xcconfig` and included via build settings.
    /// - Warning: If the key is missing, the app will crash with a `fatalError`, which is intentional for fail-fast behavior during development.
    static var clerkPublishableKey: String {
        guard let key = main.infoDictionary?["CLERK_PUBLISHABLE_KEY"] as? String else {
            fatalError(#function + ": Missing CLERK_PUBLISHABLE_KEY in Secrets.xcconfig")
        }
        return key
    }
}

/// An extension on `UserDefaults` to persist and retrieve the selected `DatabaseType`.
extension UserDefaults {
    
    /// A computed property to get/set the current database type.
    ///
    /// Persists a string representation of the `DatabaseType` in UserDefaults under the key `"DatabaseType"`.
    ///
    /// - Supported formats:
    ///   - `"InMemory"` → `.inMemory`
    ///   - `"Local"` → `.local`
    ///   - `"Firebase-<userId>"` → `.firebase(userId)`
    var databaseType: DatabaseType? {
        get {
            guard let typeString = string(forKey: "DatabaseType") else { return nil }
            
            switch typeString {
            case "InMemory":
                return .inMemory
            case "Local":
                return .local
            default:
                // Assumes format: "Firebase-<userId>"
                if typeString.starts(with: "Firebase-"),
                   let userId = typeString.split(separator: "-").last {
                    return .firebase(String(userId))
                }
                return nil
            }
        }
        set {
            set(newValue?.description, forKey: "DatabaseType")
        }
    }
    
    
    /// A computed property that tracks whether the user is signed in.
    ///
    /// This property reads and writes a boolean value to `UserDefaults` using the key `"IsSignedIn"`.
    /// Use this to persist the user's authentication state between app launches.
    var isSignedIn: Bool {
        get {
            // Retrieve the sign-in state from UserDefaults (defaults to false if the key doesn't exist).
            bool(forKey: "IsSignedIn")
        }
        set {
            // Save the updated sign-in state to UserDefaults.
            set(newValue, forKey: "IsSignedIn")
        }
    }
    
}


extension UserDefaults {
    
    /// A private enumeration containing keys used for storing values in `UserDefaults`.
    /// - Note: Keeping keys in a centralized enum helps avoid typos and makes it easier to change keys later.
    private enum Keys {
        /// The key used to store the information about whether the app has been launched before.
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }
    
    /// A computed property that tracks whether the app has been launched before.
    ///
    /// This property reads and writes a boolean value to `UserDefaults` using the key `"hasLaunchedBefore"`.
    /// - **Usage**:
    ///   - On the first launch, this value will be `false` (unless set earlier).
    ///   - You can set it to `true` after the user completes an onboarding or splash screen.
    ///   - On subsequent launches, this will return `true`, allowing you to skip onboarding.
    var hasLaunchedBefore: Bool {
        get {
            // Retrieve the "hasLaunchedBefore" value from UserDefaults.
            // If the key does not exist, it defaults to `false`.
            bool(forKey: Keys.hasLaunchedBefore)
        }
        set {
            // Save the updated "hasLaunchedBefore" state to UserDefaults.
            // This ensures the value persists across app launches.
            set(newValue, forKey: Keys.hasLaunchedBefore)
        }
    }
}




