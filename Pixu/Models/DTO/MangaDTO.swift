//
//  MangaDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation

struct MangaPageDTO: Codable {
    let items: [Manga]
    let metadata: PageMetadata
}
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

extension MangaDTO {
    var toManga: Manga {
        Manga(
            id: id,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese ?? "",
            sypnosis: sypnosis ?? "",
            background: background ?? "",
            url: (url ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\"", with: ""),
            mainPicture: (mainPicture ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\"", with: ""),
            chapters: chapters ?? 0,
            volumes: volumes ?? 0,
            score: score,
            status: status,
            startDate: startDate ?? "",

            genres: genres.map(\.toGenre),
            themes: themes.map(\.toTheme),
            demographics: demographics.map(\.toDemographic),
            authors: authors.map(\.toAuthor)
        )
    }
}
