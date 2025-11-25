//
//  File.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Fluent
import Vapor

struct MealController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let meals = routes.grouped("meals")
        let protected = meals.grouped(JWTMiddleware())
        protected.get(use: getAllMeals)
        protected.post(use: createMeal)
        protected.put(":mealID", use: updateMeal)
        protected.delete(":mealID", use: deleteMeal)
    }
    
    @Sendable
    func getAllMeals(req: Request) async throws -> [MealResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        let meals = try await Meal
            .query(on: req.db)
            .filter(\.$userID == user.requireID())
            .sort(\.$date, .descending)
            .all()
        
        return meals.map(MealResponseDTO.init)
    }
    
    @Sendable
    func createMeal(req: Request) async throws -> MealResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        let input = try req.content.decode(MealCreateDTO.self)
        
        let meal = Meal(
            userID: try user.requireID(),
            date: input.date ?? .now,
            type: input.type,
            totalCalories: input.totalCalories ?? 0,
            totalProtein: input.totalProtein ?? 0,
            totalCarbs: input.totalCarbs ?? 0,
            totalFat: input.totalFat ?? 0
        )
        
        try await meal.save(on: req.db)
        return MealResponseDTO(from: meal)
    }
    @Sendable
    func updateMeal(req: Request) async throws -> MealResponseDTO {
        guard let mealID = req.parameters.get("mealID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid meal ID")
        }
        
        let dto = try req.content.decode(MealCreateDTO.self)
        
        guard let meal = try await Meal.find(mealID, on: req.db) else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        
        // Mise à jour partielle
        meal.type = dto.type
        if let value = dto.date { meal.date = value }
        if let value = dto.totalCalories { meal.totalCalories = value }
        if let value = dto.totalProtein { meal.totalProtein = value }
        if let value = dto.totalCarbs { meal.totalCarbs = value }
        if let value = dto.totalFat { meal.totalFat = value }
        
        try await meal.save(on: req.db)
        return MealResponseDTO(from: meal)
    }
    
    // MARK: - DELETE MEAL
    @Sendable
    func deleteMeal(req: Request) async throws -> HTTPStatus {
        guard let mealID = req.parameters.get("mealID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid meal ID")
        }
        
        guard let meal = try await Meal.find(mealID, on: req.db) else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        
        try await meal.delete(on: req.db)
        return .noContent
    }
}

