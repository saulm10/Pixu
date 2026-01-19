//
//  MangaDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation

struct MangaDTO: Codable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let sypnosis: String?
    let background: String?
    let url: String?
    let mainPicture: String?
    let chapters: Int?
    let volumes: Int?
    let score: Double
    let status: String
    let startDate: String?
    let endDate: String?

    let genres: [GenreDTO]
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]
    let authors: [AuthorDTO]
}
