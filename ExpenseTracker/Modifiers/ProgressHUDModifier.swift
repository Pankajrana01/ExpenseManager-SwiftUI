//
//  ProgressHUDModifier.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 25/04/25.
//

import SwiftUI

struct ProgressHUDModifier: ViewModifier {
    @Binding var isShowing: Bool
    @Binding var title: String
    @Binding var subtitle: String?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                ProgressHUD(title: $title, subtitle: $subtitle)
            }
        }
    }
}

extension View {
    func progressHUD(isShowing: Binding<Bool>, title: Binding<String>, subtitle: Binding<String?> = .constant(nil)) -> some View {
        modifier(ProgressHUDModifier(isShowing: isShowing, title: title, subtitle: subtitle))
    }
}
