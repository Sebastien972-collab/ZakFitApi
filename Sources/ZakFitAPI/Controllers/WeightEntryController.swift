
//
//  UserController.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//

import Vapor
import Fluent

struct WeightEntryController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        let weights = routes.grouped("weights")
        let protected = weights.grouped(JWTMiddleware())
        
        protected.get(use: getAll)
        protected.post(use: createWeightEntry)
    }
    
    // MARK: - GET Weight
    @Sendable
    func getAll(req: Request) async throws -> [WeightEntryResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        let entries = try await WeightEntry
            .query(on: req.db)
            .filter(\.$userID ==  user.requireID())
            .sort(\.$date, .descending)
            .all()
        
        return entries.map(WeightEntryResponseDTO.init)
      }
      
    // MARK: - Create WeightEntry
    @Sendable
    func createWeightEntry(_ req: Request) async throws -> WeightEntryResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        let input = try req.content.decode(WeightEntryCreateDTO.self)
        let entry = WeightEntry(userID: try user.requireID(), weightkg: input.weightKg)
        try await entry.save(on: req.db)
        
        
        return WeightEntryResponseDTO(from: entry)
    }
}
