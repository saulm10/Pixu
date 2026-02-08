//
//  ThemeRepository.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 3/2/26.
//

import Foundation
import SwiftData

extension DatabaseManager {
    func resolveThemes(_ themes: [Theme]) throws -> [Theme] {
        var resolved: [Theme] = []
        for theme in themes {
            let id = theme.id
            let descriptor = FetchDescriptor<Theme>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try modelContext.fetch(descriptor).first {
                resolved.append(existing)
            } else {
                modelContext.insert(theme) 
                resolved.append(theme)
            }
        }
        return resolved
    }
}
