//
//  UserLoginVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Combine
import SwiftUI
import CommonsLib

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
        if result {
            let remoteCollections = await apiManager.collection.getCollection()
            databaseManager.syncCollection(remoteItems: remoteCollections)
        }

        if result == false {
            ToastService.shared.show(
                type: .error,
                message: "Correo o contraseña incorrectos"
            )
        }
        return result
    }

    func createUser(email: String, password: String) async -> Bool {
        let result = await apiManager.user.createUser(
            email: email,
            password: password
        )
        guard result else {
            ToastService.shared
                .show(type: .error, message: "No se pudo crear el usuario")
            return false
        }
        ToastService.shared
            .show(type: .info, message: "Usuario creado correctamente")
        return true
    }

    func loginAuth() async -> Bool {
        return await apiManager.user.loginAuth()
    }
}
