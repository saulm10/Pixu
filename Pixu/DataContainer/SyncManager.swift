//
//  SyncManager.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 2/2/26.
//

import Foundation
import SwiftData

struct SyncManager {
    let api: APIManagerProtocol
    let db: DatabaseManager
        
    func syncCollections() async {
        let remoteCollections = await api.collection.getCollection()
        await db.syncCollection(remoteItems: remoteCollections)
    }
}

extension SyncManager {
    @MainActor static let live = SyncManager(
        api: APIManager.live,
        db: DatabaseManager.shared
    )
    
    @MainActor static let preview = SyncManager(
        api: APIManager.test,
        db: DatabaseManager.shared
    )
}
