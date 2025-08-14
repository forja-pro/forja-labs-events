//
//  SettingsInteractor.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import Foundation

protocol SettingsBusinessLogic {
    func toggleDarkMode(_ isDarkMode: Bool) async
}

class SettingsInteractor: SettingsBusinessLogic {
    var viewModel: SettingsViewModel?
    
    func toggleDarkMode(_ isDarkMode: Bool) async {
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        await MainActor.run { [weak self] in
            self?.viewModel?.isDarkMode = isDarkMode
        }
    }
}
