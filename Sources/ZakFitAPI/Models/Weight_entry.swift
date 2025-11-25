//
//  File.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Vapor
import Fluent

final class WeightEntry: Model, Content, @unchecked Sendable {
    
    static let schema: String = "weight_entries"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: UUID
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "weight_kg")
    var weightKg: Double
    
    
    required init() {}
    
    init(id: UUID? = nil, userID: UUID, date: Date = .now,  weightkg: Double) {
        self.id = id
        self.userID = userID
        self.date = date
        self.weightKg = weightkg
    }
        
    
}
