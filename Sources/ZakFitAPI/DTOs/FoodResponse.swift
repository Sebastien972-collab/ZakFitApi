//
//  FoodResponse.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 25/11/2025.
//

import Fluent
import Vapor


struct FoodResponse: Content, Identifiable, Sendable {
    var id: UUID?
    var name: String
    var category: String
    
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double
    
    init(
        id: UUID? = nil ,
        name: String,
        category: String,
        caloriesPer100g: Double,
        proteinPer100g: Double,
        carbsPer100g: Double,
        fatPer100g: Double,
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.carbsPer100g = carbsPer100g
        self.fatPer100g = fatPer100g
    }
    
    /// Convenience init depuis le modèle Fluent
    init(from model: Food) {
        self.id = model.id
        self.name = model.name
        self.category = model.category
        self.caloriesPer100g = model.caloriesPer100g
        self.proteinPer100g = model.proteinPer100g
        self.carbsPer100g = model.carbsPer100g
        self.fatPer100g = model.fatPer100g
    }
}
