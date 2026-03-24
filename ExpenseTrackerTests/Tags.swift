//
//  Tags.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 17/04/25.
//

import Testing

extension Tag {
    enum expense {}
    enum income {}
    
    @Tag static var signIn: Tag
    @Tag static var signUp: Tag
    @Tag static var verifyOTP: Tag
    @Tag static var resendOTP: Tag
}

extension Tag.expense {
    @Tag static var add: Tag
    @Tag static var delete: Tag
    @Tag static var update: Tag
    @Tag static var fetch: Tag
}

extension Tag.income {
    @Tag static var add: Tag
    @Tag static var delete: Tag
    @Tag static var update: Tag
    @Tag static var fetch: Tag
}
