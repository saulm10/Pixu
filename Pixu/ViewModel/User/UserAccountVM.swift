//
//  UserAccountsVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation
import SwiftUI
import CommonsLib

@MainActor @Observable
final class UserAccountVM {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager = .shared

    let userEmail: String = ""

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }

    func deleteAllCollection() async {
        let ids = databaseManager.getAllCollection().map(\.manga.id)
        
        await withTaskGroup(of: Bool.self) { group in
            for id in ids {
                group.addTask {
                    await self.apiManager.collection.removeMangaFromCollection(id: id)
                }
            }
            
            var allSucceeded = true
            for await result in group {
                if !result { allSucceeded = false }
            }
            
            if allSucceeded {
                self.databaseManager.deleteAllDataSafely()
                ToastService.shared.show(
                    type: .success,
                    message: "Colección eliminada correctamente"
                )
            }
        }
    }

    func logOut() -> Bool {
        let result = apiManager.user.logOut()
        if result {
            databaseManager.deleteAllDataSafely()
        }
        return result ? false : true
    }
}
