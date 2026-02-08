//
//  UserAccountsVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation
import SwiftUI

@MainActor @Observable
final class UserAccountVM {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager = .shared
    
    let userEmail: String = ""

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }
    
    func logOut() -> Bool {
        let result = apiManager.user.logOut()
        if(result){
            databaseManager.deleteAllDataSafely()
        }
        return result ? false: true
    }
}
