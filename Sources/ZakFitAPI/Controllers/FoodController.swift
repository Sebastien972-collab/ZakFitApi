


//
//  FoodController.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Vapor
import Fluent

struct FoodController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let foods = routes.grouped("foods")
        let protected = foods.grouped(JWTMiddleware())
        protected.get(use: index)
        //        foods.post(use: create)          // POST /foods
        //        foods.get(":foodID", use: show)  // GET /foods/:foodID
        //        foods.put(":foodID", use: update) // PUT /foods/:foodID
        //        foods.delete(":foodID", use: delete) // DELETE /foods/:foodID
        //    }
        
        @Sendable
        /// Liste des aliments, avec filtres simples (search + category)
        func index(req: Request) async throws -> [FoodResponse] {
            let search: String? = req.query["search"]
            let category: String? = req.query["category"]
            
            var query = Food.query(on: req.db)
            
            if let search, !search.isEmpty {
                query = query.filter(\.$name, .custom("ILIKE"), "%\(search)%")
            }
            
            if let category, !category.isEmpty {
                query = query.filter(\.$category == category)
            }
            
            let foods = try await query.all()
            return foods.map(FoodResponse.init(from:))
        }
        
        /// Création d’un aliment
        //    func create(req: Request) async throws -> FoodResponse {
        //        let dto = try req.content.decode(FoodCreate.self)
        //
        //        let food = Food(
        //            name: dto.name,
        //            category: dto.category,
        //            caloriesPer100g: dto.caloriesPer100g,
        //            proteinPer100g: dto.proteinPer100g,
        //            carbsPer100g: dto.carbsPer100g,
        //            fatPer100g: dto.fatPer100g,
        //            createdByAdminID: dto.createdByAdminID
        //        )
        //
        //        try await food.save(on: req.db)
        //        return FoodResponse(from: food)
        //    }
        //
        //    /// Récupération d’un aliment par ID
        //    func show(req: Request) async throws -> FoodResponse {
        //        guard let food = try await Food.find(req.parameters.get("foodID"), on: req.db) else {
        //            throw Abort(.notFound, reason: "Aliment introuvable.")
        //        }
        //
        //        return FoodResponse(from: food)
        //    }
        //
        //    /// Mise à jour d’un aliment
        //    func update(req: Request) async throws -> FoodResponse {
        //        let dto = try req.content.decode(FoodCreate.self)
        //
        //        guard let food = try await Food.find(req.parameters.get("foodID"), on: req.db) else {
        //            throw Abort(.notFound, reason: "Aliment introuvable pour mise à jour.")
        //        }
        //
        //        food.name = dto.name
        //        food.category = dto.category
        //        food.caloriesPer100g = dto.caloriesPer100g
        //        food.proteinPer100g = dto.proteinPer100g
        //        food.carbsPer100g = dto.carbsPer100g
        //        food.fatPer100g = dto.fatPer100g
        //        food.createdByAdminID = dto.createdByAdminID
        //
        //        try await food.save(on: req.db)
        //        return FoodResponse(from: food)
        //    }
        //
        /// Suppression d’un aliment
        func delete(req: Request) async throws -> HTTPStatus {
            guard let food = try await Food.find(req.parameters.get("foodID"), on: req.db) else {
                throw Abort(.notFound, reason: "Aliment introuvable pour suppression.")
            }
            
            try await food.delete(on: req.db)
            return .noContent
        }
    }
}
