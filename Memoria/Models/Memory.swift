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
    let date: Date?
    
    init(title: String, description: String, date: Date) {
        self.title = title
        self.description = description
        self.date = date
    }
    
    ///Method to calculate date from number of days, months or years
    func getEstimatedDate(timePassedBy: Int, timeUnit: Calendar.Component) -> Date {
        var estimatedDate = Date()

        if let modifiedDate = Calendar.current.date(byAdding: timeUnit, value: -timePassedBy, to: estimatedDate) {
            estimatedDate = modifiedDate
        }

        return estimatedDate
    }
    
}
