//
//  File.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Vapor

struct MealCreateDTO: Content {
    let type: String
    let totalCalories: Double?
    let totalProtein: Double?
    let totalCarbs: Double?
    let totalFat: Double?
    let date: Date?
}
