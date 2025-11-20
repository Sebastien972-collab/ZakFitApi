//
//  User.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//


import Vapor
import Fluent

final class User: Model, Content, Authenticatable, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "first_name")
    var firstName: String

    @Field(key: "last_name")
    var lastName: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Field(key: "height_cm")
    var heightCm: Double

    @Field(key: "initial_weight_kg")
    var initialWeightKg: Double

    @Field(key: "current_weight_kg")
    var currentWeightKg: Double

    @Field(key: "diet_preferences")
    var dietPreference: String?

    @Field(key: "activity_level")
    var activityLevel: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {}

    init(id: UUID? = nil,
         firstName: String,
         lastName: String,
         email: String,
         passwordHash: String,
         heightCm: Double = 0,
         initialWeightKg: Double = 0,
         currentWeightKg: Double = 0,
         dietPreference: String = "none",
         activityLevel: String = "normal")
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.heightCm = heightCm
        self.initialWeightKg = initialWeightKg
        self.currentWeightKg = currentWeightKg
        self.dietPreference = dietPreference
        self.activityLevel = activityLevel
    }
}
