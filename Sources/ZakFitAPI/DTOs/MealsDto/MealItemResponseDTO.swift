//
//  MealItemResponseDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//


//
//  MealItemResponseDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN
//

import Vapor

struct MealItemResponseDTO: Content {
    let id: UUID
    let mealID: UUID
    let foodID: UUID
    
    let quantity: Double
    let unit: String
    
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    
    init(from item: MealItem) {
        self.id = item.id!
        self.mealID = item.$meal.id
        self.foodID = item.foodID
        self.quantity = item.quantity
        self.unit = item.unit
        self.calories = item.calories
        self.protein = item.protein
        self.carbs = item.carbs
        self.fat = item.fat
    }
}