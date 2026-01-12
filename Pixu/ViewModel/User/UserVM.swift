//
//  UserVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Combine
import SwiftUI

@Observable
final class UserVM {
    private let apiManager: APIManager
    
    var collections: [Collection] = []
    var completeCollectionsCount: Int = 0
    var totalVolumesOwned: Int = 0
    var currentlyReadingCount: Int = 0
    
    var isLoading: Bool = false

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }
    
    func loadCollections() {
        collections = Collection.testList
    }
    
    func deleteManga(_: Manga){
        
    }
    
    func deleteCollection (_: Int){
        
    }
}
