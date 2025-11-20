//
//  JWTMiddleware.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//


import Vapor
import JWT

final class JWTMiddleware: AsyncMiddleware {

    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        // Récupération du header Authorization
        guard let bearer = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized, reason: "Missing Bearer Token")
        }

        // Décodage du token
        do {
            let payload = try await request.jwt.verify(bearer.token, as: UserPayload.self)

            // Injecte l'ID utilisateur dans la requête
            request.auth.login(payload)

            return try await next.respond(to: request)

        } catch {
            throw Abort(.unauthorized, reason: "Invalid or expired token")
        }
    }
}
