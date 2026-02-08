//
//  DemographicRepository.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 3/2/26.
//

import Foundation
import SwiftData

extension DatabaseManager {
    func resolveDemographics(_ demographics: [Demographic]) throws -> [Demographic] {
        var resolved: [Demographic] = []
        for demo in demographics {
            let id = demo.id
            let descriptor = FetchDescriptor<Demographic>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try modelContext.fetch(descriptor).first {
                resolved.append(existing)
            } else {
                modelContext.insert(demo)
                resolved.append(demo)
            }
        }
        return resolved
    }
}
