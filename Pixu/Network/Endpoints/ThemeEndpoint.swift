//
//  Themes.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation
import NetworkAPI

protocol ThemesEndpoint {
    func getAllThemes() async -> [String]
}

struct Themes: ThemesEndpoint {
    let apiClient = NetworkManager.shared.client

    func getAllThemes() async -> [String] {
        do {
            return try await apiClient.get(
                path: "list/themes",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }
}

struct ThemesTest: ThemesEndpoint {
    func getAllThemes() async -> [String] {
        return ["algo", "otros"]
    }
}
