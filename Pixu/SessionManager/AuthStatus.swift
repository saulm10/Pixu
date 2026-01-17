//
//  AuthStatus.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 10/1/26.
//
import SwiftUI

@Observable
final class AuthStatus {
    var isLoggedIn: Bool = false
    var initial: Character = "U"
    var login: String = ""
}
