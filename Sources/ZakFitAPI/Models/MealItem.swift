//
//  MealItem.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Vapor
import Fluent

final class MealItem: Model, Content, @unchecked Sendable {
    
    static let schema = "meal_items"
    
    @ID(key: .id)
    var id: UUID?
    
    // Relation vers Meal
    @Parent(key: "meal_id")
    var meal: Meal
    
    // Relation vers Food (table des aliments)
    @Field(key: "food_id")
    var foodID: UUID
    
    // Quantité et unité
    @Field(key: "quantity")
    var quantity: Double
    
    @Field(key: "unit")
    var unit: String    // ex: "g", "ml", "piece"
    
    // Valeurs nutritionnelles pour CET item
    @Field(key: "calories")
    var calories: Double
    
    @Field(key: "protein")
    var protein: Double
    
    @Field(key: "carbs")
    var carbs: Double
    
    @Field(key: "fat")
    var fat: Double
    
    required init() {}
    
    init(
        id: UUID? = nil,
        mealID: UUID,
        foodID: UUID,
        quantity: Double,
        unit: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fat: Double
    ) {
        self.id = id
        self.$meal.id = mealID
        self.foodID = foodID
        self.quantity = quantity
        self.unit = unit
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
}
