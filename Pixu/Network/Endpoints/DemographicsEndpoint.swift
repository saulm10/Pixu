//
//  Demographics.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation
import NetworkAPI

protocol DemographicsEndpoint {
    func getAllDemographics() async -> [String]
}

struct Demographics: DemographicsEndpoint {
    let apiClient = NetworkManager.shared.client

    func getAllDemographics() async -> [String] {
        do {
            return try await apiClient.get(
                path: "list/demographics",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }
}

struct DemographicsTest: DemographicsEndpoint {
    func getAllDemographics() async -> [String] {
        return ["Shounen", "Seinen", "Shoujo", "Josei", "Kids"]
    }
}
