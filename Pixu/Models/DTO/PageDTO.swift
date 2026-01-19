//
//  PageDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation

struct PageDTO<T: Codable & Sendable>: Codable, Sendable {
    let items: [T]
    let metadata: PageMetadata
}

struct PageMetadata: Codable, Sendable {
    let page: Int
    let per: Int
    let total: Int
}
