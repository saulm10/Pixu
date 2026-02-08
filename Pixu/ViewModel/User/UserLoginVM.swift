//
//  UserLoginVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Combine
import SwiftUI

@MainActor @Observable
final class UserLoginVM {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager = .shared

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }

    func login(email: String, password: String) async -> Bool {
        let result = await apiManager.user.loginUser(
            email: email,
            password: password
        )
        if(result){
            let remoteCollections = await apiManager.collection.getCollection()
            databaseManager.syncCollection(remoteItems: remoteCollections)
        }
        return result
    }

    func loginAuth() async -> Bool {
        return await apiManager.user.loginAuth()
    }
}
