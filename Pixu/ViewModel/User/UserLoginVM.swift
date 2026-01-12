//
//  UserLoginVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Combine
import SwiftUI

@Observable
final class UserLoginVM {
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
