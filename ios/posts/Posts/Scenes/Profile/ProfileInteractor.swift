//
//  ProfileInteractor.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import Foundation

protocol ProfileBusinessLogic {
    func loadData(request: Profile.LoadData.Request) async
}

protocol ProfileDataStore {
    var data: ProfileEntity? { get set }
}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    var viewModel: ProfileViewModel?
    
    // MARK: - Data Store
    var data: ProfileEntity?
    
    // MARK: - Business Logic
    
    func loadData(request: Profile.LoadData.Request) async {
        viewModel?.isLoading = true
        
        // Simulate some processing time
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Create sample data (no external dependencies)
        let entity = ProfileEntity(
            id: 1,
            title: "Profile Title",
            message: "This is a basic VIP implementation"
        )
        
        self.data = entity
        
        // Direct update to ViewModel
        viewModel?.title = entity.title
        viewModel?.message = entity.message
        viewModel?.isLoading = false
    }
}
