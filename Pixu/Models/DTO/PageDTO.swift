//
//  PageDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation

struct PageMetadata: Codable {
    let page: Int
    let per: Int
    let total: Int
}
