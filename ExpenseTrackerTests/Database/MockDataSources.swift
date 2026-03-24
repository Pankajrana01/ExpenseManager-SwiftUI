//
//  MockDataSources.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 21/05/25.
//

import Foundation
@testable import ExpenseTracker

final class MockExpenseDataSource: ExpenseDataSource {
    
    private var _expenses: [DatabaseExpense] = []
    
    func create(_ item: DatabaseExpense) async throws {
        _expenses.append(item)
    }
    
    func readAll() async throws -> [DatabaseExpense] {
        _expenses
    }
    
    func update(_ item: DatabaseExpense) async throws {
        guard let index = _expenses.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _expenses[index] = item
    }
    
    func delete(_ item: DatabaseExpense) async throws {
        guard let index = _expenses.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _expenses.remove(at: index)
    }
    
    func deleteAll() async throws {
        _expenses.removeAll()
    }
}

final class MockIncomeDataSource: IncomeDataSource {
    
    private var _incomes: [DatabaseIncome] = []
    
    func create(_ item: DatabaseIncome) async throws {
        _incomes.append(item)
    }
    
    func readAll() async throws -> [DatabaseIncome] {
        _incomes
    }
    
    func update(_ item: DatabaseIncome) async throws {
        guard let index = _incomes.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _incomes[index] = item
    }
    
    func delete(_ item: DatabaseIncome) async throws {
        guard let index = _incomes.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _incomes.remove(at: index)
    }
    
    func deleteAll() async throws {
        _incomes.removeAll()
    }
}

final class MockUserDataSource: UserDataSource {
    
    private var _user: DatabaseUser?
    
    func read() async throws -> DatabaseUser? {
        _user
    }
    
    func create(_ item: DatabaseUser) async throws {
        _user = item
    }
    
    func update(_ item: DatabaseUser) async throws {
        _user = item
    }
    
    func delete(_ item: DatabaseUser) async throws {
        _user = nil
    }
}
