//
//  UserPayload.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//


import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var id: UUID
    var exp: ExpirationClaim

    init(id: UUID) {
        self.id = id
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(3600 * 24 * 30))
    }

    func verify(using algorithm: some JWTAlgorithm) async throws {
        try exp.verifyNotExpired()
    }
}
