//
//  SettingsView.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @AppStorage("isSystemAppearance") private var isSystemAppearance = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Section("Appearance") {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "moon.fill")
                                    .foregroundColor(AppTheme.primaryColor)
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Dark Mode")
                                        .font(.body)
                                        .foregroundColor(AppTheme.Colors.textPrimary)
                                    
                                    if isSystemAppearance {
                                        Text("Using System Setting")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                if isSystemAppearance {
                                    Button("Manual") {
                                        isSystemAppearance = false
                                    }
                                    .font(.caption)
                                    .foregroundColor(AppTheme.Colors.primaryBlue)
                                } else {
                                    Toggle("", isOn: $viewModel.isDarkMode)
                                        .labelsHidden()
                                        .onChange(of: viewModel.isDarkMode) {
                                            viewModel.toggleDarkMode()
                                        }
                                }
                            }
                            
                            if !isSystemAppearance {
                                HStack {
                                    Spacer()
                                    Button("Use System Setting") {
                                        isSystemAppearance = true
                                    }
                                    .font(.caption)
                                    .foregroundColor(AppTheme.Colors.primaryBlue)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.isDarkMode = isDarkMode
        }
    }
}

// MARK: - Factory Method for Creation

extension SettingsView {
    static func create() -> SettingsView {
        let interactor = SettingsInteractor()
        let viewModel = SettingsViewModel(interactor: interactor)
        
        interactor.viewModel = viewModel
        
        return SettingsView(viewModel: viewModel)
    }
}

#Preview("Light Mode") {
    SettingsView.create()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SettingsView.create()
        .preferredColorScheme(.dark)
}

#Preview("System") {
    SettingsView.create()
}
