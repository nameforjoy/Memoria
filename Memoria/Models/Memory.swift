//
//  Memory.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation

class Memory {
    let memoryID: UUID
    let title: String?
    let description: String?
    let timePassedBy: Int?
    var timeUnit: Calendar.Component?
    let hasDate: Bool

    var timeUnitAsString: String? {
        get {
            guard let timeUnit = self.timeUnit else {return nil}
            return self.getCalendarComponentAsString(component: timeUnit)
        }
    }

    var date: Date? {
        get {
            return self.getEstimatedDate(timePassedBy: self.timePassedBy, timeUnit: self.timeUnit)
        }
    }

//    init(memoryID: UUID, title: String, description: String, hasDate: Bool, timePassedBy: Int?, timeUnitAsString: String?) {
//        self.memoryID = memoryID
//        self.title = title
//        self.description = description
//        self.hasDate = hasDate
//        self.timeUnitAsString = timeUnitAsString
//        self.timePassedBy = timePassedBy
//    }

    init(memoryID: UUID, title: String, description: String, hasDate: Bool, timePassedBy: Int?, timeUnit: Calendar.Component?) {
        self.memoryID = memoryID
        self.title = title
        self.description = description
        self.hasDate = hasDate
        self.timeUnit = timeUnit
        self.timePassedBy = timePassedBy
    }


    
    ///Method to calculate date from number of days, months or years
    func getEstimatedDate(timePassedBy: Int?, timeUnit: Calendar.Component?) -> Date? {
        guard let timePassedBy = timePassedBy else {return nil}
        guard let timeUnit = timeUnit else {return nil}

        var estimatedDate = Date()

        if let modifiedDate = Calendar.current.date(byAdding: timeUnit, value: -timePassedBy, to: estimatedDate) {
            estimatedDate = modifiedDate
        }

        return estimatedDate
    }

    func getCalendarComponentAsString(component: Calendar.Component) -> String? {
        switch component {
        case .day:
            return "dias"
        case .month:
            return "meses"
        case .year:
            return "anos"
        default:
            return nil
        }
    }

    func getStringAsCalendarComponent(stringComponent: String) -> Calendar.Component? {
        switch stringComponent {
        case "dias":
            return .day
        case "meses":
            return .month
        case "anos":
            return .year
        default:
            return nil
        }
    }
    
}
