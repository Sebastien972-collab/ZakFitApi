//
//  ActivityTypeCreateDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien Daguin on 03/12/2025.
//


import Vapor
import Fluent
struct ActivityTypeCreateDTO: Content {
    let name: String
    let category: String
    let defaultCaloriesPerMinute: Double?
}

struct ActivityTypeUpdateDTO: Content {
    let name: String?
    let category: String?
    let defaultCaloriesPerMinute: Double?
}

struct ActivityTypeResponseDTO: Content {
    let id: UUID
    let name: String
    let category: String
    let defaultCaloriesPerMinute: Double?
    
    init(from model: ActivityType) throws {
        guard let id = model.id else {
            throw Abort(.internalServerError, reason: "ActivityType must have an id")
        }
        self.id = id
        self.name = model.name
        self.category = model.category
        self.defaultCaloriesPerMinute = model.defaultCaloriesPerMinute
    }
}
