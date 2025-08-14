//
//  ProfileView.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Profile View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        SettingsView.create()
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

// MARK: - Factory Method for Creation

extension ProfileView {
    static func create() -> ProfileView {
        let interactor = ProfileInteractor()
        let viewModel = ProfileViewModel(interactor: interactor)
        
        interactor.viewModel = viewModel
        
        return ProfileView(viewModel: viewModel)
    }
}

#Preview {
    ProfileView.create()
}
