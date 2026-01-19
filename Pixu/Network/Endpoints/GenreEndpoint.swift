//
//  Genres.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation
import NetworkAPI

protocol GenresEndpoint {
    func getAllGenres() async -> [String]
}

struct Genres: GenresEndpoint {
    let apiClient = NetworkManager.shared.client

    func getAllGenres() async -> [String] {
        do {
            return try await apiClient.get(
                path: "list/genres",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }
}

struct GenresTest: GenresEndpoint {
    func getAllGenres() async -> [String] {
        return ["Action", "Romance", "Comedy", "Drama", "Fantasy"]
    }
}
