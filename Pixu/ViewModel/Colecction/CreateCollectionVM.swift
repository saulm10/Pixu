//
//  CreateCollectionVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Combine
import Foundation

class CreateCollectionVM: ObservableObject {
    @Published var availableMangas: [Manga] = []
    @Published var selectedMangaId: Int?
    @Published var completeCollection = false
    @Published var volumesOwnedText = ""
    @Published var readingVolume: Int?
    
    var isValid: Bool {
        selectedMangaId != nil
    }
    
    func loadAvailableMangas() {
        // TODO: Integrar tu NetworkManager
        // GET del endpoint con todos los mangas disponibles
        // NetworkManager.shared.get("/mangas") { [weak self] (result: Result<[Manga], Error>) in
        //     DispatchQueue.main.async {
        //         switch result {
        //         case .success(let mangas):
        //             self?.availableMangas = mangas
        //         case .failure(let error):
        //             // Manejar error
        //         }
        //     }
        // }
        
        // Mock data temporal
        availableMangas = Manga.testList
    }
    
    func createCollectionRequest() -> UserCollection? {
        guard let mangaId = selectedMangaId else { return nil }
        
        let volumes: [Int]
        if completeCollection {
            let total = availableMangas.first { $0.id == mangaId }?.volumes ?? 0
            volumes = Array(1...total)
        } else {
            volumes = parseVolumes(from: volumesOwnedText)
        }
        
        return .test
//        return CollectionRequest(
//            manga: mangaId,
//            completeCollection: completeCollection,
//            volumesOwned: volumes,
//            readingVolume: readingVolume
//        )
    }
    
    private func parseVolumes(from text: String) -> [Int] {
        text.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            .sorted()
    }
}
