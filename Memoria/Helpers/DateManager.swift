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
    static func getEstimatedDate(timePassed: Int?, component: Calendar.Component?) -> Date? {
        
        guard let timePassedBy = timePassed else {return nil}
        guard let timeUnit = component else {return nil}

        var estimatedDate = Date()

        if let modifiedDate = Calendar.current.date(byAdding: timeUnit, value: -timePassedBy, to: estimatedDate) {
            estimatedDate = modifiedDate
        }

        return estimatedDate
    }

    ///Method to calculate date from number of days, months or years
    // Input as String
    static func getEstimatedDate(timePassed: Int?, timeUnit: String?) -> Date? {
        
        guard let timePassedBy = timePassed else {return nil}
        guard let timeUnit = timeUnit else {return nil}
        guard let timeUnitAsComponent = getCalendarComponentFromString(stringComponent: timeUnit) else {return nil}

        var estimatedDate = Date()

        if let modifiedDate = Calendar.current.date(byAdding: timeUnitAsComponent, value: -timePassedBy, to: estimatedDate) {
            estimatedDate = modifiedDate
        }

        return estimatedDate
    }
    
    /// Get time interval in the largest possible units (days, months or years) as a String.
    static func getTimeIntervalAsStringSinceDate(_ memory: Memory) -> String? {
        
        guard let date: Date = memory.date else {return nil}
        if !memory.hasDate {
            return nil
        }
        guard let (timePassed, component) = self.getTimeIntervalSinceDate(date: date) else {return nil}
        if timePassed == 0 {
            return TitleTexts().today
        }
        guard let timeUnit: String = self.getStringFromCalendarComponent(timePassed: timePassed, component: component) else {return nil}
        return "Há " + String(timePassed) + " " + timeUnit
    }
    
    /// Get the time interval integer and its corresponding time unit.
    /// The time unit considered is the larges largest possible between day, month and year.
    static func getTimeIntervalSinceDate(date: Date?) -> (Int, Calendar.Component)? {
        
        guard let referenceDate: Date = date else { return nil }
        
        let components = Calendar.current.dateComponents([.day, .month, .year], from: referenceDate, to: Date())
        var timePassed: Int = components.day ?? 0
        var component: Calendar.Component = .day
        
        if let years = components.year, years > 0 {
            timePassed = years
            component = .year
        } else if let months = components.month, months > 0 {
            timePassed = months
            component = .month
        }
        return (timePassed, component)
    }
    
    ///Method to convert the time passed in units of Calendar.Component as a String
    static func getStrinigFromTimeAndComponent(timePassed: Int, component: Calendar.Component) -> String? {
        
        if timePassed == 0 {
            return TitleTexts().today
        }
        guard let timeUnit: String = self.getStringFromCalendarComponent(timePassed: timePassed, component: component) else {return nil}
        return String(timePassed) + " " + timeUnit
    }

    ///Method to convert a Calendar.Component to a string in Portuguese, considering plural
    static func getStringFromCalendarComponent(timePassed: Int, component: Calendar.Component) -> String? {
        
        switch component {
        case .day:
            if timePassed == 1 {
                return "dia"
            } else {
                return "dias"
            }
        case .month:
            if timePassed == 1 {
                return "mês"
            } else {
                return "meses"
            }
        case .year:
            if timePassed == 1 {
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
