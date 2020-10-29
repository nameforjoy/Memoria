//
//  DateManager.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 29/10/20.
//

import Foundation

class DateManager {

    ///Method to calculate date from number of days, months or years
    // Input as CalendarComponent
    static func getEstimatedDate(timePassedBy: Int?, timeUnit: Calendar.Component?) -> Date? {
        guard let timePassedBy = timePassedBy else {return nil}
        guard let timeUnit = timeUnit else {return nil}

        var estimatedDate = Date()

        if let modifiedDate = Calendar.current.date(byAdding: timeUnit, value: -timePassedBy, to: estimatedDate) {
            estimatedDate = modifiedDate
        }

        return estimatedDate
    }

    ///Method to calculate date from number of days, months or years
    // Input as String
    static func getEstimatedDate(timePassedBy: Int?, timeUnit: String?) -> Date? {
        guard let timePassedBy = timePassedBy else {return nil}
        guard let timeUnit = timeUnit else {return nil}
        guard let timeUnitAsComponent = getCalendarComponentFromString(stringComponent: timeUnit) else {return nil}

        var estimatedDate = Date()

        if let modifiedDate = Calendar.current.date(byAdding: timeUnitAsComponent, value: -timePassedBy, to: estimatedDate) {
            estimatedDate = modifiedDate
        }

        return estimatedDate
    }

    ///Method to convert a Calendar.Component to a string in Portuguese, considering plural
    static func getStringFromCalendarComponent(timePasseBy: Int, component: Calendar.Component) -> String? {
        switch component {
        case .day:
            if timePasseBy == 1 {
                return "dia"
            } else {
                return "dias"
            }
        case .month:
            if timePasseBy == 1 {
                return "mês"
            } else {
                return "meses"
            }
        case .year:
            if timePasseBy == 1 {
                return "ano"
            } else {
                return "anos"
            }
        default:
            return nil
        }
    }

    ///Method to  convert string to CalendarComponent
    static func getCalendarComponentFromString(stringComponent: String) -> Calendar.Component? {
        switch stringComponent {
        case "dia":
            return .day
        case "dias":
            return .day
        case "mês":
            return .month
        case "meses":
            return .month
        case "ano":
            return .year
        case "anos":
            return .year
        default:
            return nil
        }
    }
}
