//
//  UserPublicDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//


import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String
}
