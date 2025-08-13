//
//  SettingsViewModel.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isDarkMode: Bool = false
    @Published var isSystemAppearance: Bool = true
    
    private let interactor: SettingsBusinessLogic
    
    init(interactor: SettingsBusinessLogic) {
        self.interactor = interactor
    }
    
    // MARK: - User Actions
    func toggleDarkMode() {
    Task { await interactor.toggleDarkMode(isDarkMode) }
    }
}

