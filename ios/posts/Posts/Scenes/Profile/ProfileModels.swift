//
//  ProfileModels.swift
//  Posts
//
//  Created by Vinicius Rossado on 12.08.2025.
//

import Foundation

enum Profile {
    enum LoadData {
        struct Request {
            // Add request parameters as needed
        }
    }
}

struct ProfileEntity: Identifiable, Codable {
    let id: Int
    let title: String
    let message: String
}
