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

    var isLoggedIn: Bool = false
    var initial: String = "U"
    var login: String = ""
    
    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
        Task {
            await loginAuth()
        }
    }
    
    func loginAuth() async {
        isLoggedIn = await apiManager.user.loginAuth()
    }
}
