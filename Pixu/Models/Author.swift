//
//  Author.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Foundation
import SwiftData

@Model
final class Author {
    #Index<Author>([\.id])
    @Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String
    var role: String
    
    init(id: UUID, firstName: String, lastName: String, role: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
    }
}

extension Author {

    nonisolated(unsafe) static let testList: [Author] = [
        Author(
            id: UUID(uuidString: "6F0B6948-08C4-4761-8BE1-192E68AB0A2F")!,
            firstName: "Kentarou",
            lastName: "Miura",
            role: "Story & Art"
        ),
        Author(
            id: UUID(uuidString: "0304C4E9-2D89-463A-8FDD-EEAB5B9D57B3")!,
            firstName: "",
            lastName: "Studio Gaga",
            role: "Art"
        ),
        Author(
            id: UUID(uuidString: "25617399-543F-4220-9114-3A4181AF8D80")!,
            firstName: "Eiichiro",
            lastName: "Oda",
            role: "Story & Art"
        ),
        Author(
            id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!,
            firstName: "Naoki",
            lastName: "Urasawa",
            role: "Story & Art"
        ),
        Author(
            id: UUID(uuidString: "FB305DE7-B30E-41D1-B4AB-24B7565E3840")!,
            firstName: "Takehiko",
            lastName: "Inoue",
            role: "Story & Art"
        ),
    ]

    nonisolated(unsafe) static let test: Author = Author(
        id: UUID(uuidString: "6F0B6948-08C4-4761-8BE1-192E68AB0A2F")!,
        firstName: "Kentarou",
        lastName: "Miura",
        role: "Story & Art"
    )

}
