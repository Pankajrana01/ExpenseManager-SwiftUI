//
//  AccountView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 06/05/25.
//

import PhotosUI
import SwiftUI

/// A SwiftUI view for managing and updating the user account,
/// including profile photo, name, email, and password.
struct AccountView: View {
    
    /// Used to dismiss the current view.
    @Environment(\.dismiss) private var dismiss
    
    /// View model holding user account data and handling business logic.
    @State private var viewModel: ViewModel
    
    /// Selected item from the photo picker.
    @State private var selectedItem: PhotosPickerItem?
    
    /// The image displayed as the user's profile picture.
    @State private var processedImage: Image?
    
    /// Handles authentication (e.g., sign out).
    private var authenticator: Authenticator
    
    /// Used for fetching and updating user details in the database.
    private var databaseManager: DatabaseManager

    /// Initializes the view with dependencies.
    /// - Parameters:
    ///   - authenticator: Used for authentication actions like sign out.
    ///   - databaseManager: Used for saving user details.
    ///   - notificationManager: Used for handling notification-related data.
    init(authenticator: Authenticator, databaseManager: DatabaseManager, notificationManager: NotificationManager) {
        self.authenticator = authenticator
        self.databaseManager = databaseManager
        _viewModel = State(initialValue: .init(authenticator: authenticator, databaseManager: databaseManager, notificationManager: notificationManager))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Profile image and name section
                VStack {
                    // Profile image picker
                    PhotosPicker(selection: $selectedItem) {
                        if let processedImage {
                            processedImage
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(.circle)
                                .overlay {
                                    Circle().stroke(style: StrokeStyle(lineWidth: 4))
                                }
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.green1)
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: selectedItem, loadImage) // Load image when selection changes
                    
                    Text(viewModel.name)
                        .font(.title.bold())
                    
                    Text(viewModel.email)
                }
                .padding([.top, .horizontal])
                
                // Editable form fields
                Form {
                    // First name input
                    HStack {
                        Text("First Name")
                        Spacer()
                        TextField("John", text: $viewModel.firstName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // Last name input
                    HStack {
                        Text("Last Name")
                        Spacer()
                        TextField("Doe", text: $viewModel.lastName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // Account management links
                    Section {
                        /*NavigationLink {
                            UpdateEmailView(authenticator: authenticator, databaseManager: databaseManager)
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Email")
                                Text(viewModel.email)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }*/
                        
                        VStack(alignment: .leading) {
                            Text("Email")
                            Text(viewModel.email)
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        
                        /*NavigationLink {
                            UpdatePasswordView(authenticator: authenticator, databaseManager: databaseManager)
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Password")
                                Text("********")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }*/
                    }
                    
                    Section {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily Expense Notifications")
                                if let formattedTime = viewModel.dailyExpenseNotificationSettings?.formattedTime {
                                    Text("Everyday at \(formattedTime)")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                }
                            }
                            Spacer()
                            Toggle("Daily Expense Notifications", isOn: $viewModel.enableDailyExpenseNotifications)
                                .labelsHidden()
                            
                        }
                        .onChange(of: viewModel.enableDailyExpenseNotifications) { _ , newValue in
                            if newValue {
                                Task {
                                    await viewModel.scheduleDailyExpenseNotification()
                                }
                            } else {
                                viewModel.removeAllPendingDailyExpenseNotifications()
                            }
                        }
                    }
                    
                    
                    // Sign out button
                    Button {
                        Task {
                            await viewModel.signOut()
                            dismiss()
                        }
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                    }
                    .tint(.red1)
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button in navigation bar
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Save button in navigation bar
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await viewModel.saveName()
                            dismiss()
                        }
                    }
                }
            }
            // Error alert display
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
    
    /// Loads the selected image and updates the `processedImage` state.
    private func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            processedImage = Image(uiImage: inputImage)
        }
    }
}

#Preview {
    AccountView(authenticator: FirebaseAuthenticator(), databaseManager: .initWithInMemory, notificationManager: .init(center: .init(), settings: InMemoryNotificationSettingsHandler()))
}
