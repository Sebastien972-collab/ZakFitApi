//
//  ActivityCreateDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien Daguin on 03/12/2025.
//


import Vapor
import Fluent


struct ActivityCreateDTO: Content {
    let activityTypeID: UUID
    let date: Date?           // si nil -> Date() côté serveur
    let durationMinutes: Int
    let caloriesBurned: Int?
    let intensity: String     // "faible", "modérée", "élevée", etc.
    let notes: String?
}

struct ActivityUpdateDTO: Content {
    let activityTypeID: UUID?
    let date: Date?
    let durationMinutes: Int?
    let caloriesBurned: Int?
    let intensity: String?
    let notes: String?
}

struct ActivityResponseDTO: Content {
    let id: UUID
    let userID: UUID
    let activityTypeID: UUID
    let date: Date
    let durationMinutes: Int
    let caloriesBurned: Int?
    let intensity: String
    let notes: String?
}
extension Activity {
    func toResponseDTO() throws -> ActivityResponseDTO {
        ActivityResponseDTO(
            id: try self.requireID(),
            userID: self.$user.id,
            activityTypeID: self.$activityType.id,
            date: self.date,
            durationMinutes: self.durationMinutes,
            caloriesBurned: self.caloriesBurned,
            intensity: self.intensity,
            notes: self.notes
        )
    }
}
