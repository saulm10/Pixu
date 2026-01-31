//
//  Users.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 8/1/26.
//

import Foundation
import KeyChain
import NetworkAPI

protocol UsersEndpoint {
    func createUser(email: String, password: String) async -> Bool
    func loginUser(email: String, password: String) async -> Bool
    func loginAuth() async -> Bool
    func logOut() -> Bool
}

struct Users: UsersEndpoint {
    let apiClient = NetworkManager.shared.client
    let keychain = KeychainManager.shared

    func createUser(email: String, password: String) async -> Bool {
        do {
            try await apiClient.post(
                path: "/users",
                body: CreateUserInputDTO(email: email, password: password),
                headers: [
                    "App-Token": "sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY"
                ]
            )
            return true
        } catch {
            return false
        }
    }

    func loginUser(email: String, password: String) async -> Bool {
        do {
            let response: LoginDTO = try await apiClient.post(
                path: "/users/jwt/login",
                body: nil as String?,
                temporaryAuth: .basic(username: email, password: password)
            )

            await apiClient.updateAuthToken(response.token)
            keychain.save(response.token, forKey: KeyChainK.token.rawValue)
            keychain.save(email, forKey: KeyChainK.login.rawValue)
            keychain.save(password, forKey: KeyChainK.password.rawValue)
            return true

        } catch {
            return false
        }
    }

    func loginAuth() async -> Bool {
        guard
            let token: String = keychain.read(forKey: KeyChainK.token.rawValue),
            let email: String = keychain.read(forKey: KeyChainK.login.rawValue),
            let password: String = keychain.read(forKey: KeyChainK.password.rawValue)
        else {
            return false
        }

        guard let hoursLeft = hoursLeftInJWT(token) else {
            return await loginUser(email: email, password: password)
        }

        // Token válido, reutilizar
        if hoursLeft > 0 {
            await apiClient.updateAuthToken(token)
            return true
        }

        // Token caducado hace más de 24 horas, login completo
        if hoursLeft < -24 {
            return await loginUser(email: email, password: password)
        }

        // Token expirado pero dentro de las 24 horas, intentar refresh
        do {
            let response: LoginDTO = try await apiClient.post(
                path: "/users/jwt/refresh",
                body: nil as String?,
                temporaryAuth: .bearer(token: token)
            )

            await apiClient.updateAuthToken(response.token)
            keychain.save(response.token, forKey: KeyChainK.token.rawValue)
            return true
        } catch {
            // Si falla el refresh, intentar login completo
            return await loginUser(email: email, password: password)
        }
    }

    func logOut() -> Bool {
        keychain.delete(forKey: KeyChainK.token.rawValue)
        return true
    }
}

struct UserTest: UsersEndpoint {
    func createUser(email: String, password: String) async -> Bool {
        return true
    }

    func loginUser(email: String, password: String) async -> Bool {
        return true
    }

    func loginAuth() async -> Bool {
        return true
    }

    func logOut() -> Bool {
        return true
    }
}
