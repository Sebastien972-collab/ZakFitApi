

//
//  Food.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Vapor
import Fluent

final class Food: Model, Content, @unchecked Sendable {
    
    static let schema = "foods"
    
    @ID(key: .id)
    var id: UUID?
    
    // Nom de l'aliment
    @Field(key: "name")
    var name: String
    
    // Catégorie (Fruit, Légume, Viande, etc.)
    @Field(key: "category")
    var category: String
    
    // Valeurs nutritionnelles pour 100 g
    @Field(key: "calories_per_100g")
    var caloriesPer100g: Double
    
    @Field(key: "protein_per_100g")
    var proteinPer100g: Double
    
    @Field(key: "carbs_per_100g")
    var carbsPer100g: Double
    
    @Field(key: "fat_per_100g")
    var fatPer100g: Double
    
    // Optionnel : lien vers l’admin qui a créé l’aliment
    @OptionalField(key: "created_by_admin_id")
    var createdByAdminID: UUID?
    
    // MARK: - Inits
    
    required init() {}
    
    init(
        id: UUID? = nil,
        name: String,
        category: String,
        caloriesPer100g: Double,
        proteinPer100g: Double,
        carbsPer100g: Double,
        fatPer100g: Double,
        createdByAdminID: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.carbsPer100g = carbsPer100g
        self.fatPer100g = fatPer100g
        self.createdByAdminID = createdByAdminID
    }
}
