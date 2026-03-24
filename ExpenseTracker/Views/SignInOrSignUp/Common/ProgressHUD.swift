//
//  ProgressHUD.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 25/04/25.
//

import SwiftUI

struct ProgressHUD: View {
    @Binding var title: String
    @Binding var subtitle: String?
    
    init(title: Binding<String>, subtitle: Binding<String?> = .constant(nil)) {
        self._title = title
        self._subtitle = subtitle
    }
    
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(2)
                .tint(.green1)
            Text(title)
                .font(.title2.weight(.medium))
                .foregroundStyle(.green1)
                .padding([.top, .horizontal])
            if let subtitle {
                Text(subtitle)
                    .font(.title3)
                    .foregroundStyle(.green1)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ProgressHUD(title: .constant("Loading..."), subtitle: .constant("Please wait..."))
}
