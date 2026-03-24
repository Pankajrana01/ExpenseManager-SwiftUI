//
//  Utility.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

extension DatabaseManager {
    /// A `DatabaseManager` instance configured to use UserDefaults as the local data store.
    ///
    /// This is useful for simple persistence that survives app restarts but
    /// doesn't require a full database. It sets up repositories backed by
    /// UserDefaults data sources for expenses, incomes, and user details.
    static var initWithUserDefaults: DatabaseManager {
        .init(
            localRepositoryHandler: RepositoryHandlerImpl(
                expenseRepository: ExpenseDataRepository(dataSource: UserDefaultsExpenseDataSource()),
                incomeRepository: IncomeDataRepository(dataSource: UserDefaultsIncomeDataSource()),
                userRepository: UserDataRepository(dataSource: UserDefaultsUserDataSource())
            )
        )
    }
    
    /// A `DatabaseManager` instance configured to use in-memory storage as the local data store.
    ///
    /// Data is stored only during app runtime and lost upon termination.
    /// This is useful for testing, previews, or ephemeral data scenarios.
    /// Repositories use in-memory data sources for expenses, incomes, and user details.
    static var initWithInMemory: DatabaseManager {
        .init(
            localRepositoryHandler: RepositoryHandlerImpl(
                expenseRepository: ExpenseDataRepository(dataSource: InMemoryExpenseDataSource()),
                incomeRepository: IncomeDataRepository(dataSource: InMemoryIncomeDataSource()),
                userRepository: UserDataRepository(dataSource: InMemoryUserDataSource())
            )
        )
    }
}

/// Creates a remote `RepositoryHandler` configured to interact with Firestore for a given user.
///
/// - Parameter userId: The unique identifier of the authenticated user.
/// - Returns: A `RepositoryHandler` with Firestore-backed repositories for expenses, incomes, and user data.
///
/// This method creates repositories that connect to Firestore collections scoped to the user ID,
/// enabling cloud sync and storage of the user's financial data.
func firestoreRepositoryHandler(userId: String) -> RepositoryHandler {
    return RepositoryHandlerImpl(
        expenseRepository: ExpenseDataRepository(dataSource: FirestoreExpenseDataSource(userId: userId)),
        incomeRepository: IncomeDataRepository(dataSource: FirestoreIncomeDataSource(userId: userId)),
        userRepository: UserDataRepository(dataSource: FirestoreUserDataSource(userId: userId))
    )
}
