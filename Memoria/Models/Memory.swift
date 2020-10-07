//
//  Memory.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation

class Memory: Codable {
    let title: String?
    let description: String?
    let days: Int?
    let months: Int?
    let years: Int?
    
    init(title: String, description: String, days: Int, months: Int, years: Int) {
        self.title = title
        self.description = description
        self.days = days
        self.months = months
        self.years = years
    }
    
}
