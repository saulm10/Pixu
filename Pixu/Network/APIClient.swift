//
//  ApiClient.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Foundation
import NetworkAPI

struct NetworkManager {
    static let shared = NetworkManager()
    
    let client: NetworkClient
    
    private init() {
        let config = NetworkConfig(
            baseURL:  "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/",
            keyDecodingStrategy: .convertFromPascalCase,
        )
        self.client = NetworkClient(config: config)
    }
}
