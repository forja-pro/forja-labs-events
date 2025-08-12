//
//  SettingsInteractor.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import Foundation

protocol SettingsBusinessLogic {
    func toggleDarkMode(_ isDarkMode: Bool)
}

class SettingsInteractor: SettingsBusinessLogic {
    var viewModel: SettingsViewModel?

    func toggleDarkMode(_ isDarkMode: Bool) {
        // Update UserDefaults to persist the setting
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        
        // Update the ViewModel to reflect the change in UI
        Task { @MainActor in
            viewModel?.isDarkMode = isDarkMode
        }
    }
    

}
