//
//  AuthController.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//

import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
    }
    
    // POST /auth/register
    @Sendable
    func register(_ req: Request) async throws -> TokenResponse {
        let data = try req.content.decode(RegisterRequest.self)
        
        // Vérifier si email existe déjà
        if try await User.query(on: req.db).filter(\.$email == data.email).first() != nil {
            throw Abort(.conflict, reason: "Cette adresse email est déjà utilisée.")
        }
        
        // Hash du mot de passe
        let passwordHash = try Bcrypt.hash(data.password)
        
        let user = User(
            firstName: data.firstName,
            lastName: data.lastName,
            email: data.email,
            passwordHash: passwordHash
        )
        
        try await user.save(on: req.db)
        
        // Générer le JWT
        let payload = UserPayload(id: try user.requireID())
        let token = try await req.jwt.sign(payload)
        
        return TokenResponse(token: token)
    }
    
    // POST /auth/login
    func login(_ req: Request) async throws -> TokenResponse {
        let data = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == data.email)
            .first()
        else {
            throw Abort(.unauthorized, reason: "Identifiants incorrects.")
        }
        
        // Vérifier mot de passe
        if try !Bcrypt.verify(data.password, created: user.passwordHash) {
            throw Abort(.unauthorized, reason: "Mot de passe incorrects.")
        }
        
        let payload = UserPayload(id: try user.requireID())
        let token = try await req.jwt.sign(payload)
        
        return TokenResponse(token: token)
    }
}
