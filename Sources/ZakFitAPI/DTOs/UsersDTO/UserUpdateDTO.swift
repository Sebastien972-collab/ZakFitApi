//
//  UserUpdateDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//


import Vapor

struct UserUpdateDTO: Content {
    let firstName: String?
    let lastName: String?
    let email: String?
    
    let heightCm: Double?
    let initialWeightKg: Double?
    let currentWeightKg: Double?
    
    let dietPreference: String?
    let activityLevel: String?
}