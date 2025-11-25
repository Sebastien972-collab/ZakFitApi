//
//  WeightEntryResponseDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Fluent
import Vapor

struct WeightEntryResponseDTO: Content {
    let id: UUID?
    let userID: UUID
    let date: Date
    let weightKg: Double
    
    init(from model: WeightEntry) {
        self.id = model.id
        self.userID = model.userID
        self.date = model.date
        self.weightKg = model.weightKg
    }
}
