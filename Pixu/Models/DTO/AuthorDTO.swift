//
//  AuthorDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation

struct AuthorPageDTO: Codable {
    let items: [Author]
    let metadata: PageMetadata
}

struct AuthorDTO: Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let role: String
}

extension AuthorDTO {
    var toAuthor: Author {
        Author(id: id, firstName: firstName, lastName: lastName, role: role)
    }
}
