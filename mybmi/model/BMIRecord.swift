//
//  BMIRecord.swift
//  mybmi
//
//  Created by Roxy  on 20/2/25.
//


import SwiftUI

struct BMIRecord: Codable, Identifiable {
    let id: UUID
    let gender: String
    let weight: Int
    let height: Double
    let age: Int
    let activityLevel: String
    let bmi: Double
    let category: String
    let date: Date

    init(gender: String, weight: Int, height: Double, age: Int, activityLevel: String, bmi: Double, category: String, date: Date) {
        self.id = UUID() // Unique ID for ForEach
        self.gender = gender
        self.weight = weight
        self.height = height
        self.age = age
        self.activityLevel = activityLevel
        self.bmi = bmi
        self.category = category
        self.date = date
    }
}
