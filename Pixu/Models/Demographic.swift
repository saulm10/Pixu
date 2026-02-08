//
//  Demographic.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Foundation
import SwiftData

@Model
final class Demographic {
    @Attribute(.unique) var id: UUID
    var demographic: String

    @Relationship(inverse: \Manga.demographics)
    var mangas: [Manga] = []

    init(id: UUID, demographic: String) {
        self.id = id
        self.demographic = demographic
    }
}

extension Demographic {
    nonisolated(unsafe) static let testList: [Demographic] = [
        Demographic(
            id: UUID(uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D")!,
            demographic: "Seinen"
        ),
        Demographic(
            id: UUID(uuidString: "5E05BBF1-A72E-4231-9487-71CFE508F9F9")!,
            demographic: "Shounen"
        ),
    ]

    nonisolated(unsafe) static let test: Demographic = Demographic(
        id: UUID(uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D")!,
        demographic: "Seinen"
    )

}
