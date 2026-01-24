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
    var isLoggedIn: Bool = false
    var initial: String = "U"
    var login: String = ""
}
