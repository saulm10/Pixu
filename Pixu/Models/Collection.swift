//
//  UserCollection.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Foundation
import SwiftData

@Model
final class UserCollection {
    @Attribute(.unique) var id: UUID
    var completeCollection: Bool
    var readingVolume: Int?
    var volumesOwned: [Int]

    @Relationship(deleteRule: .cascade)
    var manga: Manga

    init(
        id: UUID,
        completeCollection: Bool,
        readingVolume: Int? = nil,
        volumesOwned: [Int],
        manga: Manga
    ) {
        self.id = id
        self.completeCollection = completeCollection
        self.readingVolume = readingVolume
        self.volumesOwned = volumesOwned
        self.manga = manga
    }
}

extension UserCollection {

    nonisolated(unsafe) static let testList: [UserCollection] = [
        UserCollection(
            id: UUID(),
            completeCollection: true,
            readingVolume: 1,
            volumesOwned: [1],
            manga: .testList.first!
        ),
        UserCollection(
            id: UUID(),
            completeCollection: false,
            readingVolume: 3,
            volumesOwned: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            manga: .testList.last!
        ),
    ]

    nonisolated(unsafe) static let test = UserCollection(
        id: UUID(),
        completeCollection: true,
        readingVolume: 1,
        volumesOwned: [1, 2, 10],
        manga: .test
    )

}
