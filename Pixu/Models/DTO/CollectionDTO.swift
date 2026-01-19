//
//  CollectionDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation

struct CollectionDTO: Codable {
    let id: UUID
    let completeCollection: Bool
    let readingVolume: Int
    let volumesOwned: [Int]
    let manga: MangaDTO
}
