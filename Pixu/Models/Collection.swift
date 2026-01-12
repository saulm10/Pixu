//
//  Collection.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Foundation

struct Collection: Codable, Identifiable {
    let id: UUID
    let completeCollection: Bool
    let readingVolume: Int?
    let volumesOwned: [Int]
    let manga : Manga
}

extension Collection {
    
    static let testList: [Collection] = [
        .test,
        .test
    ]
    
    static let test = Collection(
        id: UUID(),
        completeCollection: true,
        readingVolume: 1,
        volumesOwned: [1, 2, 10],
        manga: .test
    )
    
}

