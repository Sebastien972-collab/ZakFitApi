//
//  RegisterRequest.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 20/11/2025.
//


import Vapor

struct RegisterRequest: Content {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
