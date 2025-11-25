//
// MealItemController.swift
// ZakFitAPI
//
// Created by Sébastien DAGUIN
//

import Vapor
import Fluent

struct MealItemController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        let items = routes.grouped("meal-items")
        let protected = items.grouped(JWTMiddleware())
        
        // GET : tous les items d'un repas
        protected.get(":mealID", use: getItemsForMeal)
        
        // POST : création d'un item -> IDs dans le DTO
        protected.post(use: addItemToMeal)
        
        // UPDATE / DELETE par itemID (REST classique)
        protected.put(":itemID", use: updateItem)
        protected.delete(":itemID", use: deleteItem)
    }
    
    // MARK: - GET ALL ITEMS FOR A MEAL
    @Sendable
    func getItemsForMeal(req: Request) async throws -> [MealItemResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        _ = payload.id
        
        guard let mealID = req.parameters.get("mealID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid meal ID")
        }
        
        let items = try await MealItem
            .query(on: req.db)
            .filter(\.$meal.$id == mealID)
            .all()
        
        return items.map(MealItemResponseDTO.init)
    }
    
    // MARK: - ADD ITEM TO MEAL (IDs dans le DTO)
    @Sendable
    func addItemToMeal(req: Request) async throws -> MealItemResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        _ = payload.id
        
        let dto = try req.content.decode(MealItemCreateDTO.self)
        
        // Vérifier que le meal existe
        guard let _ = try await Meal.find(dto.mealID, on: req.db) else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        print("Les id sont reçus\n \(dto.mealID) pour le meal et \(dto.foodID) pour la nourriture")
        let item = MealItem(
            mealID: dto.mealID,
            foodID: dto.foodID,
            quantity: dto.quantity,
            unit: dto.unit,
            calories: dto.calories,
            protein: dto.protein,
            carbs: dto.carbs,
            fat: dto.fat
        )
        
        do {
            try await item.save(on: req.db)
            return MealItemResponseDTO(from: item)
        } catch {
            // Ceci affichera l'erreur précise de Postgres dans votre console Xcode
            print("❌ ERREUR POSTGRES DÉTAILLÉE : \(String(reflecting: error))")
            throw error
        }
        
//        // Recalcul des totaux du meal
//        try await recalcMealTotals(mealID: dto.mealID, db: req.db)
        
        return MealItemResponseDTO(from: item)
    }
    
    // MARK: - UPDATE ITEM
    @Sendable
    func updateItem(req: Request) async throws -> MealItemResponseDTO {
        guard let itemID = req.parameters.get("itemID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid item ID")
        }
        
        let dto = try req.content.decode(MealItemCreateDTO.self)
        
        guard let item = try await MealItem.find(itemID, on: req.db) else {
            throw Abort(.notFound, reason: "Meal item not found")
        }
        
        // Mise à jour
        item.quantity = dto.quantity
        item.unit = dto.unit
        item.calories = Double(dto.calories) // Assurez-vous que le DTO fournit déjà un Double
        item.protein = dto.protein
        item.carbs = dto.carbs
        item.fat = dto.fat
        
        try await item.save(on: req.db)
        
        // Recalcul du meal
        do {
            //try await recalcMealTotals(mealID: item.$meal.id, db: req.db)
        } catch  {
           print(String(reflecting: error))
        }
        
        
        return MealItemResponseDTO(from: item)
    }
    
    // MARK: - DELETE ITEM
    @Sendable
    func deleteItem(req: Request) async throws -> HTTPStatus {
        guard let itemID = req.parameters.get("itemID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid item ID")
        }
        
        guard let item = try await MealItem.find(itemID, on: req.db) else {
            throw Abort(.notFound, reason: "Item not found")
        }
        
        let mealID = item.$meal.id
        try await item.delete(on: req.db)
        
        // Mise à jour des totaux après suppression
       // try await recalcMealTotals(mealID: mealID, db: req.db)
        
        return .noContent
    }
    
//    // MARK: - Recalc Nutrition Totals for a Meal
//    private func recalcMealTotals(mealID: UUID, db: any Database) async throws {
//        guard let meal = try await Meal.find(mealID, on: db) else { return }
//        
//        let items = try await MealItem
//            .query(on: db)
//            .filter(\.$meal.$id == mealID)
//            .all()
//        
//        // CORRECTION: Utiliser 0.0 et $1.calories (Double) pour éviter la perte de précision et la confusion de type
//        meal.totalCalories = items.reduce(0.0) { $0 + $1.calories }
//        meal.totalProtein  = items.reduce(0.0) { $0 + $1.protein }
//        meal.totalCarbs    = items.reduce(0.0) { $0 + $1.carbs }
//        meal.totalFat      = items.reduce(0.0) { $0 + $1.fat }
//        
//        try await meal.save(on: db)
//    }
}
