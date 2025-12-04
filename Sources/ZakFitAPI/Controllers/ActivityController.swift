// ActivityController.swift
// ZakFitAPI

import Vapor
import Fluent

struct ActivityController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let base = routes.grouped("activities")
        
        // Groupe protégé via ton middleware JWT
        let protected = base.grouped(JWTMiddleware())
        
        protected.post(use: create)
        protected.get(use: list)
        protected.get(":id", use: getOne)
        protected.delete(":id", use: delete)
        // Tu pourras rajouter update plus tard si besoin
    }
    
    // MARK: - POST /activities
    /// Création d’une nouvelle activité pour l’utilisateur courant
    func create(req: Request) async throws -> ActivityResponseDTO {
        let payload = try req.auth.require(UserPayload.self)

        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        let dto = try req.content.decode(ActivityCreateDTO.self)
        
        // Vérifier que le type existe
        guard let type = try await ActivityType.find(dto.activityTypeID, on: req.db) else {
            throw Abort(.badRequest, reason: "Invalid activityTypeID")
        }
        
        let activity = Activity(
            userID: try user.requireID(),
            activityTypeID: try type.requireID(),
            date: dto.date ?? Date(),
            durationMinutes: dto.durationMinutes,
            caloriesBurned: dto.caloriesBurned,
            intensity: dto.intensity,
            notes: dto.notes
        )
        
        try await activity.save(on: req.db)
        return try activity.toResponseDTO()
    }
    
    // MARK: - GET /activities
    /// Liste des activités de l’utilisateur courant (sans filtres pour l’instant)
    func list(req: Request) async throws -> [ActivityResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)

        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        let activities = try await Activity.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .sort(\.$date, .descending)
            .all()
        
        return try activities.map { try $0.toResponseDTO() }
    }
    
    // MARK: - GET /activities/:id
    func getOne(req: Request) async throws -> ActivityResponseDTO {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing id")
        }
        
        guard let activity = try await Activity.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userID)
            .first()
        else {
            throw Abort(.notFound, reason: "Activity not found")
        }
        
        return try activity.toResponseDTO()
    }
    
    // MARK: - DELETE /activities/:id
    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing id")
        }
        
        guard let activity = try await Activity.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$user.$id == userID)
            .first()
        else {
            throw Abort(.notFound, reason: "Activity not found")
        }
        
        try await activity.delete(on: req.db)
        return .noContent
    }
}
