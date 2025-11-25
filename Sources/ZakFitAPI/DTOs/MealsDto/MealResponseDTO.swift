//
//  MealResponseDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//


import Vapor

struct MealResponseDTO: Content {
    let id: UUID?
    let userID: UUID
    let date: Date
    let type: String
    let totalCalories: Double
    let totalProtein: Double
    let totalCarbs: Double
    let totalFat: Double
    
    init(from meal: Meal) {
        self.id = meal.id
        self.userID = meal.userID
        self.date = meal.date
        self.type = meal.type
        self.totalCalories = meal.totalCalories
        self.totalProtein = meal.totalProtein
        self.totalCarbs = meal.totalCarbs
        self.totalFat = meal.totalFat
    }
}