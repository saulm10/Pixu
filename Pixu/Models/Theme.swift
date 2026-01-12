//
//  Theme.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import Foundation

struct Theme: Codable, Identifiable {
    let id: UUID
    let theme: String
}

extension Theme {

    static let testList: [Theme] = [
        Theme(
            id: UUID(uuidString: "82728A80-0DBE-4B64-A295-A25555A4A4A5")!,
            theme: "Gore"
        ),
        Theme(
            id: UUID(uuidString: "4394C99F-615B-494A-929E-356A342A95B8")!,
            theme: "Psychological"
        ),
        Theme(
            id: UUID(uuidString: "3CF0EDA7-5856-40F7-A0CF-EC676B4A842C")!,
            theme: "Historical"
        ),
        Theme(
            id: UUID(uuidString: "04238A83-08E4-4066-AE4C-D5024609F8F0")!,
            theme: "Samurai"
        ),
        Theme(
            id: UUID(uuidString: "AD119CBB-2CCE-42FE-BD89-32D42C46462F")!,
            theme: "Military"
        ),
    ]

    static let test: Theme = Theme(
        id: UUID(uuidString: "82728A80-0DBE-4B64-A295-A25555A4A4A5")!,
        theme: "Gore"
    )

}
