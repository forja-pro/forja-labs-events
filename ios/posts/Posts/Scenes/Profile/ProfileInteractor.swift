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

        print("Hello from ProfileInteractor")
    
    }
}
