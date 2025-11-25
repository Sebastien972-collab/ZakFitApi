//
//  WeightEntryCreateDTO.swift
//  ZakFitAPI
//
//  Created by Sébastien DAGUIN on 24/11/2025.
//

import Fluent
import Vapor

struct WeightEntryCreateDTO: Content {
    let weightKg: Double
}
