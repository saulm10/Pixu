//
//  Genre.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Foundation
import SwiftData

@Model
final class Genre {
    #Index<Genre>([\.genre])
    @Attribute(.unique) var id: UUID
    var genre: String
    
    init(id: UUID, genre: String) {
        self.id = id
        self.genre = genre
    }
}

extension Genre {

    nonisolated(unsafe) static let testList: [Genre] = [
        Genre(
            id: UUID(uuidString: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD")!,
            genre: "Action"
        ),
        Genre(
            id: UUID(uuidString: "BE70E289-D414-46A9-8F15-928EAFBC5A32")!,
            genre: "Adventure"
        ),
        Genre(
            id: UUID(uuidString: "4C13067F-96FF-4F14-A1C0-B33215F24E0B")!,
            genre: "Award Winning"
        ),
        Genre(
            id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!,
            genre: "Drama"
        ),
        Genre(
            id: UUID(uuidString: "97C8609D-856C-419E-A4ED-E13A5C292663")!,
            genre: "Mystery"
        ),
    ]

    nonisolated(unsafe) static let test: Genre = Genre(
        id: UUID(uuidString: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD")!,
        genre: "Action"
    )

}
