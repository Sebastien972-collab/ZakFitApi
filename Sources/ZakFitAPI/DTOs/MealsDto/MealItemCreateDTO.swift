//
//  MealItemCreateDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Vapor

struct MealItemCreateDTO: Content {
    let mealID: UUID
    let foodID: UUID
    let quantity: Double
    let unit: String
    
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
}
