//
//  ProfileViewModel.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var isLoading: Bool = false
    
    private let interactor: ProfileBusinessLogic
    
    init(interactor: ProfileBusinessLogic) {
        self.interactor = interactor
    }
    
    // MARK: - User Actions
    func loadData() {
        Task {
            let request = Profile.LoadData.Request()
            await interactor.loadData(request: request)
        }
    }
}
