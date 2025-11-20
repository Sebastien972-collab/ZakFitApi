//
//  UserController.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//

import Vapor
import Fluent

struct UserController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        let protected = users.grouped(JWTMiddleware())

        protected.get("me", use: getProfile)
        protected.put("update", use: updateProfile)
    }

    // MARK: - GET PROFILE
    @Sendable
    func getProfile(_ req: Request) async throws -> UserPublicDTO {
        let payload = try req.auth.require(UserPayload.self)

        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        return user.toPublicDTO()
    }

    // MARK: - UPDATE PROFILE
    @Sendable
    func updateProfile(_ req: Request) async throws -> UserPublicDTO {
        let payload = try req.auth.require(UserPayload.self)
        let input = try req.content.decode(UserUpdateDTO.self)

        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        // Mise à jour sécurisée, champs optionnels
        if let v = input.firstName { user.firstName = v }
        if let v = input.lastName { user.lastName = v }
        if let v = input.email { user.email = v }

        if let v = input.heightCm { user.heightCm = v }
        if let v = input.initialWeightKg { user.initialWeightKg = v }
        if let v = input.currentWeightKg { user.currentWeightKg = v }

        if let v = input.dietPreference { user.dietPreference = v }
        if let v = input.activityLevel { user.activityLevel = v }

        try await user.save(on: req.db)

        return user.toPublicDTO()
    }
}
