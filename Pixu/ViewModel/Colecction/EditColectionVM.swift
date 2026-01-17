//
//  EditColectionVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Combine
import Foundation

@MainActor @Observable
class EditColectionVM: ObservableObject {
    let collection: Collection
    
    var completeCollection: Bool
    var volumesOwnedText: String
    var readingVolume: Int?
    var showDeleteConfirmation = false
    
    init(collection: Collection) {
        self.collection = collection
        self.completeCollection = collection.completeCollection
        self.volumesOwnedText = collection.volumesOwned.map(String.init).joined(separator: ",")
        self.readingVolume = collection.readingVolume
    }
    
    func updateCollectionRequest() -> Collection? {
        let volumes: [Int]
        if completeCollection {
            let total = collection.manga.volumes ?? 0
            volumes = Array(1...total)
        } else {
            volumes = parseVolumes(from: volumesOwnedText)
        }
        return .test
//        return Collection(
//            id: collection.id,
//            completeCollection: collection.manga,
//            readingVolume: completeCollection,
//            volumesOwned: volumes,
//            manga: readingVolume
//        )
    }
    
    func deleteCollection() {
        // TODO: Integrar tu NetworkManager
        // DELETE /collection/manga/<mangaID>
    }
    
    private func parseVolumes(from text: String) -> [Int] {
        text.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            .sorted()
    }
}
