//
//  AuthorDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation

struct AuthorDTO: Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let role: String
}
