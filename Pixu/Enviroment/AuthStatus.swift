//
//  AuthStatus.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 10/1/26.
//
import SwiftUI


import SwiftUI

@MainActor @Observable
final class AuthStatus {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager

    var isLoggedIn: Bool = false
    var initial: String = "U"
    var login: String = ""
    
    init(
        apiManager: APIManager = .live,
        databaseManager: DatabaseManager = .shared
    ) {
        self.apiManager = apiManager
        self.databaseManager = databaseManager
        Task{
            isLoggedIn = await apiManager.user.loginAuth()
            guard isLoggedIn else { return }
            let remoteCollections = await apiManager.collection.getCollection()
            databaseManager.syncCollection(remoteItems: remoteCollections)
        }
    }
}
