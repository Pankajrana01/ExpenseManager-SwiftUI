//
//  AppFont.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 14/08/25.
//

import SwiftUI

enum AppFont {
    
    enum Poppins: String {
        case regular    = "Poppins-Regular"
        case bold       = "Poppins-Bold"
        case extraBold  = "Poppins-ExtraBold"
        case light      = "Poppins-Light"
        case medium     = "Poppins-Medium"
        case semiBold   = "Poppins-SemiBold"
        case italic     = "Poppins-Italic"
    }
    
    // MARK: - SwiftUI
    static func poppins(_ type: Poppins, size: CGFloat) -> Font {
        return Font.custom(type.rawValue, size: size)
    }
}
