//
//  DatabaseUser.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// Represents a user stored in the database.
///
/// This struct conforms to `Codable` to facilitate easy encoding and decoding
/// when persisting data to and retrieving data from storage solutions like
/// Firestore or UserDefaults.
struct DatabaseUser: Codable {
    
    /// Unique identifier for the user.
    ///
    /// This should be a stable and unique string, typically a UUID or user ID
    /// assigned by the backend or authentication system.
    var id: String
    
    /// The user's email address.
    ///
    /// Optional because the email might not be provided or required depending
    /// on the authentication or user registration flow.
    var email: String?
    
    /// The user's first name.
    ///
    /// Optional because it might not be set immediately or could be absent for
    /// some users.
    var firstName: String?
    
    /// The user's last name.
    ///
    /// Optional because it might not be set immediately or could be absent for
    /// some users.
    var lastName: String?
}
