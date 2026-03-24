//
//  UserDefaultsUserDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// A concrete implementation of `UserDataSource` that persists a single `DatabaseUser`
/// instance using `UserDefaults`. The user data is stored as JSON under a specific key.
///
/// This implementation is suitable for lightweight, local user profile management.
final class UserDefaultsUserDataSource: UserDataSource {
    
    /// Internal backing property for the user data.
    ///
    /// Any time this property is modified (`didSet`), it is encoded into JSON and
    /// saved to `UserDefaults` under the key `UserDefaultsDataSourceKey.userDetails`.
    /// If the value is `nil`, the stored value is removed from `UserDefaults`.
    private var _user: DatabaseUser? {
        didSet {
            if let data = try? JSONEncoder().encode(_user) {
                UserDefaults.standard.set(data, forKey: UserDefaultsDataSourceKey.userDetails)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsDataSourceKey.userDetails)
            }
        }
    }
    
    /// Initializes the data source by attempting to load an existing user
    /// from `UserDefaults`. If decoding fails or no data is found, `_user` remains `nil`.
    init() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsDataSourceKey.userDetails) {
            if let decode = try? JSONDecoder().decode(DatabaseUser.self, from: data) {
                _user = decode
            }
        }
    }
    
    /// Returns the current stored user (if any).
    ///
    /// - Returns: A `DatabaseUser` instance or `nil` if no user is stored.
    /// - Throws: Never throws directly, but conforms to the async throws signature.
    func read() async throws -> DatabaseUser? {
        _user
    }
    
    /// Stores a new user in the data source.
    ///
    /// - Parameter item: The `DatabaseUser` to persist.
    /// - Throws: Never throws directly, but conforms to the async throws signature.
    func create(_ item: DatabaseUser) async throws {
        _user = item
    }
    
    /// Updates the current user.
    ///
    /// - Parameter item: The updated `DatabaseUser` instance.
    /// - Throws: Never throws directly, but conforms to the async throws signature.
    func update(_ item: DatabaseUser) async throws {
        _user = item
    }
    
    /// Deletes the current user by setting `_user` to `nil` and removing it from `UserDefaults`.
    ///
    /// - Parameter item: The `DatabaseUser` to delete (only the presence of the ID is relevant).
    /// - Throws: Never throws directly, but conforms to the async throws signature.
    func delete(_ item: DatabaseUser) async throws {
        _user = nil
    }    
}
