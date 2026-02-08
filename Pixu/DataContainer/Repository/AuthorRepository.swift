//
//  AuthorRepository.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 3/2/26.
//

import Foundation
import SwiftData

extension DatabaseManager {
    func resolveAuthors(_ authors: [Author]) throws -> [Author] {
        var resolved: [Author] = []
        for author in authors {
            let id = author.id
            let descriptor = FetchDescriptor<Author>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try modelContext.fetch(descriptor).first {
                resolved.append(existing)
            } else {
                modelContext.insert(author)
                resolved.append(author)
            }
        }
        return resolved
    }
}
