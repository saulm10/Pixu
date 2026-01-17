//
//  InputDTOs.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation

struct CustomSearchInputDTO: Codable {
    let searchContains: Bool
    let searchTitle: String?
    let searchAuthorFirstName: String?
    let searchAuthorLastName: String?
    let searchGenres: [String]?
    let searchThemes: [String]?
    let searchDemographics: [String]?
}
