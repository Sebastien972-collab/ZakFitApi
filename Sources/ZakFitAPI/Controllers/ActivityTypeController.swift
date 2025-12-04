//
//  ActivityTypeCreateDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien Daguin on 03/12/2025.
//


// ActivityTypeController.swift
// ZakFitAPI

import Vapor
import Fluent

struct ActivityTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let types = routes.grouped("activity-types")
        let protected = types.grouped(JWTMiddleware())
        // Lecture (pour l’app)
        protected.get(use: list)
        protected.get(":id", use: getOne)
        
        // À PROTÉGER avec un middleware admin plus tard
        // let admin = types.grouped(AdminUser.authenticator(), AdminUser.guardMiddleware())
        // admin.post(use: create)
        // admin.put(":id", use: update)
        // admin.delete(":id", use: delete)
        
        protected.post(use: create)
        protected.put(":id", use: update)
        protected.delete(":id", use: delete)
    }
    
    
    // GET /activity-types?category=cardio
    @Sendable
    func list(req: Request) async throws -> [ActivityTypeResponseDTO] {
        struct Filters: Content {
            var category: String?
        }
        let filters = try req.query.decode(Filters.self)
        
        var query = ActivityType.query(on: req.db).sort(\.$name, .ascending)
        
        if let cat = filters.category {
            query = query.filter(\.$category == cat)
        }
        
        let items = try await query.all()
        return try items.map(ActivityTypeResponseDTO.init(from:))
    }
    
    // GET /activity-types/:id
    func getOne(req: Request) async throws -> ActivityTypeResponseDTO {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing id")
        }
        
        guard let model = try await ActivityType.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ActivityType not found")
        }
        
        return try ActivityTypeResponseDTO(from: model)
    }
    
    // POST /activity-types
    func create(req: Request) async throws -> ActivityTypeResponseDTO {
        let dto = try req.content.decode(ActivityTypeCreateDTO.self)
        
        let model = ActivityType(
            name: dto.name,
            category: dto.category,
            defaultCaloriesPerMinute: dto.defaultCaloriesPerMinute,
            createdByAdminID: nil // à renseigner via auth admin si besoin
        )
        
        try await model.save(on: req.db)
        return try ActivityTypeResponseDTO(from: model)
    }
    
    // PUT /activity-types/:id
    func update(req: Request) async throws -> ActivityTypeResponseDTO {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing id")
        }
        
        guard let model = try await ActivityType.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ActivityType not found")
        }
        
        let dto = try req.content.decode(ActivityTypeUpdateDTO.self)
        
        if let name = dto.name {
            model.name = name
        }
        if let category = dto.category {
            model.category = category
        }
        if let defaultCals = dto.defaultCaloriesPerMinute {
            model.defaultCaloriesPerMinute = defaultCals
        }
        
        try await model.save(on: req.db)
        return try ActivityTypeResponseDTO(from: model)
    }
    
    // DELETE /activity-types/:id
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing id")
        }
        
        guard let model = try await ActivityType.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ActivityType not found")
        }
        
        try await model.delete(on: req.db)
        return .noContent
    }
}
