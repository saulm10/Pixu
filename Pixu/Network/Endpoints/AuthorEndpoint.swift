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
    func getAuthorsPaged(page: Int, per: Int) async -> PageDTO<Author>
    func getAuthorsByIds(ids: [UUID]) async -> [Author]
}

struct Authors: AuthorsEndpoint {
    let apiClient = NetworkManager.shared.client

    func getAllAuthors() async -> [Author] {
        do {
            return try await apiClient.get(
                path: "list/authors",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }

    func getAuthorsPaged(page: Int = 1, per: Int = 10) async -> PageDTO<Author> {
        do {
            return try await apiClient.get(
                path: "list/authorsPaged",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
        } catch {
            return PageDTO<Author>(
                items: [],
                metadata: PageMetadata(page: 1, per: 10, total: 0)
            )
        }
    }

    func getAuthorsByIds(ids: [UUID]) async -> [Author] {
        do {
            return try await apiClient.post(
                path: "list/authorsByIds",
                body: ["ids": ids],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }
}

struct AuthorsTest: AuthorsEndpoint {
    func getAllAuthors() async -> [Author] {
        return Author.testList
    }

    func getAuthorsPaged(page: Int = 1, per: Int = 10) async -> PageDTO<Author> {
        return PageDTO<Author>(
            items: Author.testList,
            metadata: PageMetadata(
                page: page,
                per: per,
                total: Author.testList.count
            )
        )
    }

    func getAuthorsByIds(ids: [UUID]) async -> [Author] {
        return Author.testList.filter { ids.contains($0.id) }
    }
}
