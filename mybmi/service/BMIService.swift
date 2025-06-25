//
//  BMIService.swift
//  mybmi
//
//  Created by Roxy  on 20/2/25.
//


class BMIService {
    func calculateBMI(weight: Double, height: Double) -> (Double, String) {
        let bmi = weight / (height * height)
        let category: String
        
        switch bmi {
        case ..<18.5: category = "UnderWeight"
        case 18.5..<25: category = "Normal"
        case 25..<30: category = "Overweight"
        case 30..<35: category = "Obese Class I"
        case 35..<40: category = "Obese Class II"
        default: category = "Obese Class III"
        }
        
        return (bmi, category)
    }
}
