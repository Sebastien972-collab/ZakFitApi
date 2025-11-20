//
//  UserPublicDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//


import Vapor

struct UserPublicDTO: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String

    let heightCm: Double
    let initialWeightKg: Double
    let currentWeightKg: Double

    let dietPreference: String?
    let activityLevel: String
    
    let createdAt: Date?
    let updatedAt: Date?
}