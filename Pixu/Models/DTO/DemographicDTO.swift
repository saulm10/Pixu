//
//  DemographicDTO.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation

struct DemographicDTO: Codable {
    let id: UUID
    let demographic: String
}

extension DemographicDTO {
    var toDemographic: Demographic {
        Demographic(id: id, demographic: demographic)
    }
}
