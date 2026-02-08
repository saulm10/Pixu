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
    private let syncManager: SyncManager

    var isLoggedIn: Bool = false
    var initial: String = "U"
    var login: String = ""
    
    init(apiManager: APIManager = .live, syncManager: SyncManager = .live) {
        self.apiManager = apiManager
        self.syncManager = syncManager
        Task{
            isLoggedIn = await apiManager.user.loginAuth()
            guard isLoggedIn else { return }
            await syncManager.syncCollections()
        }
    }
}
