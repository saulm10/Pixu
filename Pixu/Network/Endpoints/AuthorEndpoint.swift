//
//  Authors.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation
import NetworkAPI

protocol AuthorsEndpoint {
    func getAllAuthors() async -> [Author]
    func getAuthorsPaged(page: Int, per: Int) async -> [Author]
    func getAuthorsByIds(ids: [UUID]) async -> [Author]
}

struct Authors: AuthorsEndpoint {
    let apiClient = NetworkManager.shared.client

    func getAllAuthors() async -> [Author] {
        do {
            let dto: [AuthorDTO] = try await apiClient.get(
                path: "list/authors",
                queryParameters: [:],
                temporaryAuth: nil
            )
            return dto.map(\.toAuthor)
        } catch {
            return []
        }
    }

    func getAuthorsPaged(page: Int = 1, per: Int = 10) async -> [Author] {
        do {
            let dto: [AuthorDTO] = try await apiClient.get(
                path: "list/authorsPaged",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
            return dto.map(\.toAuthor)
        } catch {
            return []
        }
    }

    func getAuthorsByIds(ids: [UUID]) async -> [Author] {
        do {
            let dto: [AuthorDTO] = try await apiClient.post(
                path: "list/authorsByIds",
                body: ["ids": ids],
                temporaryAuth: nil
            )
            return dto.map(\.toAuthor)
        } catch {
            return []
        }
    }
}

struct AuthorsTest: AuthorsEndpoint {
    func getAllAuthors() async -> [Author] {
        return Author.testList
    }

    func getAuthorsPaged(page: Int = 1, per: Int = 10) async -> [Author] {
        return Author.testList
    }

    func getAuthorsByIds(ids: [UUID]) async -> [Author] {
        return Author.testList.filter { ids.contains($0.id) }
    }
}
