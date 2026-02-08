//
//  Genre.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 3/2/26.
//

import Foundation
import SwiftData

extension DatabaseManager {
    func resolveGenres(_ genres: [Genre]) throws -> [Genre] {
        var resolved: [Genre] = []
        for genre in genres {
            let id = genre.id
            let descriptor = FetchDescriptor<Genre>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try modelContext.fetch(descriptor).first {
                resolved.append(existing)
            } else {
                modelContext.insert(genre) 
                resolved.append(genre)
            }
        }
        return resolved
    }
}
