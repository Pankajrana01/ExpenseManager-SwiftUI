//
//  OTPView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 19/04/25.
//

import SwiftUI

/// A customizable OTP (One-Time Password) input view.
///
/// This view displays a horizontal stack of text fields allowing the user to input a multi-digit OTP code.
/// It automatically handles focus navigation between fields and limits each field to one numeric character.
struct OTPView: View {
    
    /// Total number of OTP fields.
    let numberOfFields: Int
    
    /// Two-way binding to the OTP code string assembled from user input.
    @Binding var otpCode: String
    
    /// Array storing individual characters of the OTP input.
    @State private var otpDigits: [String]
    
    /// Keeps track of the currently focused text field index.
    @FocusState private var focusedField: Int?
    
    /// Initializes the OTPView with a given number of fields and a binding to the final OTP code.
    ///
    /// - Parameters:
    ///   - numberOfFields: Number of individual OTP input fields. Default is 6.
    ///   - otpCode: A `Binding` to the full OTP code that gets updated as user types.
    init(numberOfFields: Int = 6, otpCode: Binding<String>) {
        self.numberOfFields = numberOfFields
        self._otpCode = otpCode
        self._otpDigits = State(initialValue: Array(repeating: "", count: numberOfFields))
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Create a text field for each digit in the OTP
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $otpDigits[index])
                    .font(.title) // Large, readable font
                    .tint(.clear) // Hide the text cursor
                    .keyboardType(.numberPad) // Limit to numeric input
                    .multilineTextAlignment(.center) // Center the digit in the field
                    .frame(height: 70) // Uniform height
                    .overlay(
                        // Draw a border that turns green when filled or focused
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                (otpDigits[index].isNotEmpty || focusedField == index)
                                    ? .green1 : .gray,
                                lineWidth: 1.5
                            )
                    )
                    .focused($focusedField, equals: index) // Manage focus per field
                    .onChange(of: otpDigits[index]) { oldValue, newValue in
                        // Handle input change, validate and navigate focus
                        processInput(index: index, oldValue: oldValue, newValue: newValue)
                    }
                    .onTapGesture {
                        // Set focus to tapped field
                        focusedField = index
                    }
            }
        }
        .onAppear {
            // Set initial focus to the first field
            focusedField = 0
        }
        .onChange(of: otpDigits) { _, _ in
            // Update the full OTP code when any digit changes
            updateOTPCode()
        }
    }
    
    /// Processes user input for a specific OTP digit field.
    ///
    /// Ensures that only one character is stored, and auto-navigates to the next or previous field
    /// based on user action (input or delete).
    private func processInput(index: Int, oldValue: String, newValue: String) {
        // Ensure only a single numeric character is allowed
        if newValue.count > 1 {
            let filtered = newValue.filter { $0.isNumber && String($0) != oldValue }
            otpDigits[index] = filtered.isEmpty ? oldValue : String(filtered.prefix(1))
        }
        
        // Move to next field when user types a character
        if !newValue.isEmpty && index < numberOfFields - 1 {
            focusedField = index + 1
        }
        // Move to previous field on delete
        else if newValue.isEmpty && index > 0 {
            focusedField = index - 1
        }
    }
    
    /// Joins all OTP digit values and updates the binding to the full OTP code.
    private func updateOTPCode() {
        otpCode = otpDigits.joined()
    }
}


#Preview {
    OTPView(otpCode: .constant(""))
}
