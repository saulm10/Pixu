//
//  APIManager.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Foundation
import NetworkAPI
import SwiftUI

protocol APIManagerProtocol {
    var user: UserEndpoint { get }
//    var fichaje: FichajeEndpoint { get }
//    var dedicaciones: DedicacionesEndpoint { get }
}

struct APIManager: APIManagerProtocol {
    let user: UserEndpoint
//    let fichaje: FichajeEndpoint
//    let dedicaciones: DedicacionesEndpoint

    static let live = APIManager(
        user: Users(),
//        fichaje: Fichaje(),
//        dedicaciones: Dedicaciones()
    )

    static let test = APIManager(
        user: UserTest(),
//        fichaje: FichajeTest(),
//        dedicaciones: DedicacionesTest()
    )
}
