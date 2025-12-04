//
//  Activity.swift
//  ZakFitAPI
//
//  Created by Sébastien Daguin on 03/12/2025.
//

import Vapor
import Fluent

/// Activité physique réalisée par un utilisateur
final class Activity: Model, Content, @unchecked Sendable {
    static let schema: String = "activities"
    
    @ID(key: .id)
    var id: UUID?
    
    // MARK: - Relations
    
    /// Utilisateur propriétaire de l’activité
    @Parent(key: "user_id")
    var user: User
    
    /// Type d’activité (FK vers ActivityType)
    @Parent(key: "activity_type_id")
    var activityType: ActivityType
    
    // MARK: - Données métier
    
    /// Date/heure de l’activité
    @Field(key: "date")
    var date: Date
    
    /// Durée en minutes
    @Field(key: "duration_minutes")
    var durationMinutes: Int
    
    /// Calories brûlées (optionnel)
    @OptionalField(key: "calories_burned")
    var caloriesBurned: Int?
    
    /// Intensité : "faible", "modérée", "élevée"...
    @Field(key: "intensity")
    var intensity: String
    
    /// Notes libres
    @OptionalField(key: "notes")
    var notes: String?
    
    init() {}
    
    init(
        id: UUID? = nil,
        userID: UUID,
        activityTypeID: UUID,
        date: Date,
        durationMinutes: Int,
        caloriesBurned: Int?,
        intensity: String,
        notes: String?
    ) {
        self.id = id
        self.$user.id = userID
        self.$activityType.id = activityTypeID
        self.date = date
        self.durationMinutes = durationMinutes
        self.caloriesBurned = caloriesBurned
        self.intensity = intensity
        self.notes = notes
    }
}
