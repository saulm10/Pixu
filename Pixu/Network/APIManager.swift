//
//  APIManager.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Foundation
import NetworkAPI
import SwiftUI

protocol APIManagerProtocol {
    var search: SearchEndpoint { get }
    var collection: CollectionEndpoint { get }
    var manga: MangasEndpoint { get }
    var author: AuthorsEndpoint { get }
    var demographic: DemographicsEndpoint { get }
    var theme: ThemesEndpoint { get }
    var genre: GenresEndpoint { get }
    var user: UsersEndpoint { get }
}

struct APIManager: APIManagerProtocol, @unchecked Sendable {
    let search: SearchEndpoint
    let collection: CollectionEndpoint
    let manga: MangasEndpoint
    let author: AuthorsEndpoint
    let demographic: DemographicsEndpoint
    let theme: ThemesEndpoint
    let genre: GenresEndpoint
    let user: UsersEndpoint

    static let live = APIManager(
        search: Searchs(),
        collection: Collections(),
        manga: Mangas(),
        author: Authors(),
        demographic: Demographics(),
        theme: Themes(),
        genre: Genres(),
        user: Users(),
    )

    static let test = APIManager(
        search: SearchsTest(),
        collection: CollectionsTest(),
        manga: MangasTest(),
        author: AuthorsTest(),
        demographic: DemographicsTest(),
        theme: ThemesTest(),
        genre: GenresTest(),
        user: UserTest(),
    )
}

