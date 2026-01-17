//
//  ThemeDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation

struct ThemeDTO: Codable {
    var id: UUID
    let theme: String
}

extension ThemeDTO{
    var toTheme: Theme {
        Theme(id: id, theme: theme)
    }
}
