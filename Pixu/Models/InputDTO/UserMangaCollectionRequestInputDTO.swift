//
//  UserMangaCollectionRequestInputDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

struct UserMangaCollectionRequestInputDTO: Codable {
    let manga: Int
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
}
