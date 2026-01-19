//
//  Pager.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 19/1/26.
//

import SwiftUI

@Observable
final class Pager<T: Identifiable> {
    // Estado de los datos
    var items: [T] = []
    var currentPage: Int = 0
    var isLoading: Bool = false
    var hasReachedEnd: Bool = false
    
    // Configuración
    private let pageSize: Int
    private let fetchProvider: (Int) async throws -> [T]
    
    init(pageSize: Int = 20, fetchProvider: @escaping (Int) async throws -> [T]) {
        self.pageSize = pageSize
        self.fetchProvider = fetchProvider
    }
    
    func loadNextPage() async {
        guard !isLoading && !hasReachedEnd else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newItems = try await fetchProvider(currentPage)
            if newItems.count < pageSize {
                hasReachedEnd = true
            }
            items.append(contentsOf: newItems)
            currentPage += 1
        } catch {
            print("Error cargando página: \(error)")
        }
    }
    
    func reset() {
        items = []
        currentPage = 0
        hasReachedEnd = false
        isLoading = false
    }
}
