//
//  ActivityType.swift
//  ZakFitAPI
//
//  Created by Sébastien Daguin on 03/12/2025.
//

import Vapor
import Fluent

/// Type d’activité (course, marche, yoga, etc.)
final class ActivityType: Model, Content, @unchecked Sendable {
    static let schema: String = "activity_types"
    
    @ID(key: .id)
    var id: UUID?
    
    /// Nom affiché : "Course à pied", "Marche rapide"...
    @Field(key: "name")
    var name: String
    
    /// Catégorie : "cardio", "musculation", "bien-être"...
    @Field(key: "category")
    var category: String
    
    /// Calories par minute par défaut
    @OptionalField(key: "default_calories_per_minute")
    var defaultCaloriesPerMinute: Double?
    
    /// Admin créateur du type (nullable, on reste simple avec juste l’ID)
    @OptionalField(key: "created_by_admin_id")
    var createdByAdminID: UUID?
    
    init() {}
    
    init(
        id: UUID? = nil,
        name: String,
        category: String,
        defaultCaloriesPerMinute: Double? = nil,
        createdByAdminID: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.defaultCaloriesPerMinute = defaultCaloriesPerMinute
        self.createdByAdminID = createdByAdminID
    }
}
