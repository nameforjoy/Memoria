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

    // Method to convert estimatedDate to TimePassedBy + TimeUnit
    // Pegar do lifeTree
    func getTimeSinceLastEntry(lastDate: Date) -> String {

        let periodInSeconds = lastDate.distance(to: Date())
        let periodInMinutes = Int(periodInSeconds / 60)

        // Minutes
        if periodInMinutes < 60 {
            if periodInMinutes == 1 {
                return "há \(periodInMinutes) minuto"
            } else {
                return "há \(periodInMinutes) minutos"
            }
        }
        // Hours
        else {
            let periodInHours = Int(periodInMinutes / 60)
            if periodInHours < 24 {
                if periodInHours == 1 {
                    return "há \(periodInHours) hora"
                } else {
                    return "há \(periodInHours) horas"
                }
            }
            // Days
            else {
                let periodInDays = Int(periodInHours / 24)
                if periodInDays < 7 {
                    if periodInDays == 1 {
                        return "há \(periodInDays) dia"
                    } else {
                        return "há \(periodInDays) dias"
                    }
                }
                // Weeks
                else {
                    let periodInWeeks = Int(periodInDays / 7)
                    if periodInWeeks == 1 {
                        return "há \(periodInWeeks) semana"
                    } else {
                        return "há \(periodInWeeks) semanas"
                    }
                }
            }
        }
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
