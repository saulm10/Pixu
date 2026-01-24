//
//  Pager.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 19/1/26.
//

import SwiftUI
import Combine

actor PageState {
    private var page = 0
    private var isLoading = false
    private var hasMorePages = true
    
    func nextPage() -> Int? {
        guard !isLoading, hasMorePages else { return nil }
        isLoading = true
        page += 1
        return page
    }
    
    func finishLoading(hasMore: Bool = true) {
        isLoading = false
        hasMorePages = hasMore
    }
    
    func reset() {
        page = 0
        isLoading = false
        hasMorePages = true
    }
}
