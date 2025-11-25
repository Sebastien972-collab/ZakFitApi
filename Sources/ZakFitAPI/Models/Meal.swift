//
//  File.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Vapor
import Fluent

final class Meal: Model, Content, @unchecked Sendable {
    
    static let schema: String = "meals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: UUID
    
    @Field(key: "datetime")
    var date: Date
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "total_calories")
    var totalCalories: Double
    
    @Field(key: "total_protein")
    var totalProtein: Double
    
    @Field(key: "total_carbs")
    var totalCarbs: Double
    
    @Field(key: "total_fat")
    var totalFat: Double
    
    
    required init() {}
    
    init(
        id: UUID? = nil,
        userID: UUID,
        date: Date = .now,
        type: String,
        totalCalories: Double = 0,
        totalProtein: Double = 0,
        totalCarbs: Double = 0,
        totalFat: Double = 0
    ) {
        self.id = id
        self.userID = userID
        self.date = date
        self.type = type
        self.totalCalories = totalCalories
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFat = totalFat
    }
}
