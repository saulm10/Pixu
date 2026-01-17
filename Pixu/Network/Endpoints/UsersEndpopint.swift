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
            return true

        } catch {
            return false
        }
    }

    func loginAuth() async -> Bool {
        do {
            let token: String? = keychain.read(forKey: KeyChainK.token.rawValue)
            guard let token else {
                return false
            }

            let hourLeftToken: Double? = hoursLeftInJWT(token)

            if hourLeftToken ?? 0 > 2 {
                await apiClient.updateAuthToken(token)
                return true
            }

            let response: LoginDTO = try await apiClient.post(
                path: "/users/jwt/refresh",
                body: nil as String?,
                temporaryAuth: .bearer(token: token)
            )
            
            await apiClient.updateAuthToken(response.token)
            keychain.save(response.token, forKey: KeyChainK.token.rawValue)
            return true
        } catch {
            return false
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
