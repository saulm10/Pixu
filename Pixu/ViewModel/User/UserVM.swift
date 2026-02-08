//
//  UserVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Combine
import SwiftUI

@MainActor @Observable
final class UserVM {
    private let apiManager: APIManager
    
    var state: ViewState = .empty
    
    var completeCollectionsCount: Int = 0
    var totalVolumesOwned: Int = 0
    var currentlyReadingCount: Int = 0
    
    var selectedManga: Manga?
    
    var isLoading: Bool = false

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }
}
