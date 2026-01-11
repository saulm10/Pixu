//
//  HomeTabVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI

@Observable
final class HomeTabVM {
    private let apiManager: APIManager

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }
    
}
