//
//  Pager.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 19/1/26.
//

import SwiftUI

@Observable @MainActor
final class Pager<T: Identifiable> {
    var items: [T] = []
    var currentPage: Int = 1
    var isLoading: Bool = false
    var hasReachedEnd: Bool = false
    
    private let pageSize: Int
    private let fetchProvider: (Int, Int) async throws -> [T]
    
    init(pageSize: Int = 20, fetchProvider: @escaping (Int, Int) async throws -> [T]) {
        self.pageSize = pageSize
        self.fetchProvider = fetchProvider
    }
    
    func loadNextPage() async {
        // Check y set en una sola operación
        guard !isLoading && !hasReachedEnd else { return }
        isLoading = true  // ← Ya está bien posicionado
        
        defer { isLoading = false }
        
        do {
            let newItems = try await fetchProvider(currentPage, pageSize)
            print("✅ Página \(currentPage): recibidos \(newItems.count) items")
            if newItems.count < pageSize {
                hasReachedEnd = true
            }
            items.append(contentsOf: newItems)
            currentPage += 1
        } catch {
            print("❌ Error cargando página: \(error)")
        }
    }
    
    func reset() {
        items = []
        currentPage = 0
        hasReachedEnd = false
        isLoading = false
    }
}
