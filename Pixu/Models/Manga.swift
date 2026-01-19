//
//  Manga.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//
import Foundation

struct Manga: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String
    let sypnosis: String?
    let background: String?
    let url: String?
    let mainPicture: String?
    let chapters: Int?
    let volumes: Int?
    let score: Double
    let status: String
    let startDate: String

    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]
    let authors: [Author]

    var cleanURL: String {
        url?.replacingOccurrences(of: "\\", with: "")
            .replacingOccurrences(of: "\"", with: "") ?? ""
    }

    var cleanMainPicture: String {
        mainPicture?.replacingOccurrences(of: "\\", with: "")
            .replacingOccurrences(of: "\"", with: "") ?? ""
    }
}

extension Manga {

    static let testList: [Manga] = [
        Manga(
            id: 2,
            title: "Berserk",
            titleEnglish: "Berserk",
            titleJapanese: "ベルセルク",
            sypnosis:
                "Guts, a former mercenary now known as the Black Swordsman, seeks revenge...",
            background:
                "Berserk won the Award for Excellence at the Tezuka Osamu Cultural Prize.",
            url: "https://myanimelist.net/manga/2/Berserk",
            mainPicture:
                "https://cdn.myanimelist.net/images/manga/1/157897l.jpg",
            chapters: 1,
            volumes: 1,
            score: 9.47,
            status: "currently_publishing",
            startDate: "1989-08-25T00:00:00Z",
            genres: [
                Genre(
                    id: UUID(
                        uuidString: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD"
                    )!,
                    genre: "Action"
                ),
                Genre(
                    id: UUID(
                        uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD"
                    )!,
                    genre: "Drama"
                ),
            ],
            themes: [
                Theme(
                    id: UUID(
                        uuidString: "82728A80-0DBE-4B64-A295-A25555A4A4A5"
                    )!,
                    theme: "Gore"
                )
            ],
            demographics: [
                Demographic(
                    id: UUID(
                        uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D"
                    )!,
                    demographic: "Seinen"
                )
            ],
            authors: [
                Author(
                    id: UUID(
                        uuidString: "6F0B6948-08C4-4761-8BE1-192E68AB0A2F"
                    )!,
                    firstName: "Kentarou",
                    lastName: "Miura",
                    role: "Story & Art"
                )
            ]
        ),
        Manga(
            id: 1706,
            title: "Steel Ball Run",
            titleEnglish: nil,
            titleJapanese: "ジョジョの奇妙な冒険 Part7",
            sypnosis: "The greatest race across America is about to begin...",
            background: "Originally serialized as an unrelated story to JoJo.",
            url: "https://myanimelist.net/manga/1706",
            mainPicture:
                "https://cdn.myanimelist.net/images/manga/3/179882l.jpg",
            chapters: 96,
            volumes: 24,
            score: 9.30,
            status: "finished",
            startDate: "2004-01-19T00:00:00Z",
            genres: [
                Genre(
                    id: UUID(
                        uuidString: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD"
                    )!,
                    genre: "Action"
                ),
                Genre(
                    id: UUID(
                        uuidString: "97C8609D-856C-419E-A4ED-E13A5C292663"
                    )!,
                    genre: "Mystery"
                ),
            ],
            themes: [
                Theme(
                    id: UUID(
                        uuidString: "3CF0EDA7-5856-40F7-A0CF-EC676B4A842C"
                    )!,
                    theme: "Historical"
                )
            ],
            demographics: [
                Demographic(
                    id: UUID(
                        uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D"
                    )!,
                    demographic: "Seinen"
                )
            ],
            authors: [
                Author(
                    id: UUID(
                        uuidString: "30B3A8B4-7A8D-4913-8370-28975F785354"
                    )!,
                    firstName: "Hirohiko",
                    lastName: "Araki",
                    role: "Story & Art"
                )
            ]
        ),
        Manga(
            id: 656,
            title: "Vagabond",
            titleEnglish: "Vagabond",
            titleJapanese: "バガボンド",
            sypnosis: "The fictional retelling of Musashi Miyamoto’s life...",
            background: "Winner of multiple cultural and manga awards.",
            url: "https://myanimelist.net/manga/656/Vagabond",
            mainPicture:
                "https://cdn.myanimelist.net/images/manga/1/259070l.jpg",
            chapters: 327,
            volumes: 37,
            score: 9.24,
            status: "on_hiatus",
            startDate: "1998-09-03T00:00:00Z",
            genres: [
                Genre(
                    id: UUID(
                        uuidString: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD"
                    )!,
                    genre: "Action"
                )
            ],
            themes: [
                Theme(
                    id: UUID(
                        uuidString: "04238A83-08E4-4066-AE4C-D5024609F8F0"
                    )!,
                    theme: "Samurai"
                )
            ],
            demographics: [
                Demographic(
                    id: UUID(
                        uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D"
                    )!,
                    demographic: "Seinen"
                )
            ],
            authors: [
                Author(
                    id: UUID(
                        uuidString: "FB305DE7-B30E-41D1-B4AB-24B7565E3840"
                    )!,
                    firstName: "Takehiko",
                    lastName: "Inoue",
                    role: "Story & Art"
                )
            ]
        ),
        Manga(
            id: 13,
            title: "One Piece",
            titleEnglish: "One Piece",
            titleJapanese: "ONE PIECE",
            sypnosis:
                "A young pirate named Luffy sets out to find One Piece...",
            background: "The best-selling manga series of all time.",
            url: "https://myanimelist.net/manga/13/One_Piece",
            mainPicture:
                "https://cdn.myanimelist.net/images/manga/2/253146l.jpg",
            chapters: 1,
            volumes: 1,
            score: 9.22,
            status: "currently_publishing",
            startDate: "1997-07-22T00:00:00Z",
            genres: [
                Genre(
                    id: UUID(
                        uuidString: "BE70E289-D414-46A9-8F15-928EAFBC5A32"
                    )!,
                    genre: "Adventure"
                )
            ],
            themes: [],
            demographics: [
                Demographic(
                    id: UUID(
                        uuidString: "5E05BBF1-A72E-4231-9487-71CFE508F9F9"
                    )!,
                    demographic: "Shounen"
                )
            ],
            authors: [
                Author(
                    id: UUID(
                        uuidString: "25617399-543F-4220-9114-3A4181AF8D80"
                    )!,
                    firstName: "Eiichiro",
                    lastName: "Oda",
                    role: "Story & Art"
                )
            ]
        ),
        Manga(
            id: 1,
            title: "Monster",
            titleEnglish: "Monster",
            titleJapanese: "MONSTER",
            sypnosis: "A surgeon’s life changes after saving a child...",
            background: "Winner of multiple awards including Tezuka Prize.",
            url: "https://myanimelist.net/manga/1/Monster",
            mainPicture:
                "https://cdn.myanimelist.net/images/manga/3/258224l.jpg",
            chapters: 162,
            volumes: 18,
            score: 9.15,
            status: "finished",
            startDate: "1994-12-05T00:00:00Z",
            genres: [
                Genre(
                    id: UUID(
                        uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD"
                    )!,
                    genre: "Drama"
                )
            ],
            themes: [
                Theme(
                    id: UUID(
                        uuidString: "4394C99F-615B-494A-929E-356A342A95B8"
                    )!,
                    theme: "Psychological"
                )
            ],
            demographics: [
                Demographic(
                    id: UUID(
                        uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D"
                    )!,
                    demographic: "Seinen"
                )
            ],
            authors: [
                Author(
                    id: UUID(
                        uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD"
                    )!,
                    firstName: "Naoki",
                    lastName: "Urasawa",
                    role: "Story & Art"
                )
            ]
        ),
    ]

    static let test: Manga = Manga(
        id: 2,
        title: "Berserk",
        titleEnglish: "Berserk",
        titleJapanese: "ベルセルク",
        sypnosis:
            "Guts, a former mercenary now known as the Black Swordsman, seeks revenge...",
        background:
            "Berserk won the Award for Excellence at the Tezuka Osamu Cultural Prize.",
        url: "https://myanimelist.net/manga/2/Berserk",
        mainPicture: "https://cdn.myanimelist.net/images/manga/1/157897l.jpg",
        chapters: 1,
        volumes: 1,
        score: 9.47,
        status: "currently_publishing",
        startDate: "1989-08-25T00:00:00Z",
        genres: [
            Genre(
                id: UUID(uuidString: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD")!,
                genre: "Action"
            ),
            Genre(
                id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!,
                genre: "Drama"
            ),
        ],
        themes: [
            Theme(
                id: UUID(uuidString: "82728A80-0DBE-4B64-A295-A25555A4A4A5")!,
                theme: "Gore"
            )
        ],
        demographics: [
            Demographic(
                id: UUID(uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D")!,
                demographic: "Seinen"
            )
        ],
        authors: [
            Author(
                id: UUID(uuidString: "6F0B6948-08C4-4761-8BE1-192E68AB0A2F")!,
                firstName: "Kentarou",
                lastName: "Miura",
                role: "Story & Art"
            )
        ]
    )

}
