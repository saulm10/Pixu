//
//  UserTabVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI

@Observable
final class UserTabVM {
    private let apiManager: APIManager

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }

    func login(email: String, password: String) async -> Bool {
        return await apiManager.user.loginUser(
            email: email,
            password: password
        )
    }
    
    func loginAuth() async -> Bool {
        return await apiManager.user.loginAuth()
    }
}
