//
//  TimerManager.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 23/10/20.
//

import Foundation

class TimerManager {
    
    let timeInterval: Double
    
    init(timeInterval: Double) {
        self.timeInterval = timeInterval
    }
    
    func getTimeInSeconds(timerCount: Double, withdecimalPlaces places: Int = 1) -> Double {
        let timeInSeconds = timerCount * self.timeInterval
        return timeInSeconds.round(toPlaces: places)
    }
    
    func getTimeString(timerCount: Double, withdecimalPlaces places: Int = 1) -> String {
        var seconds = getTimeInSeconds(timerCount: timerCount, withdecimalPlaces: places)
        let minutes = Int(truncating: NSNumber(value: seconds / 60))
        seconds -= Double(minutes) * 60
        let decimalSeconds = seconds.truncatingRemainder(dividingBy: 1) * pow(10.0, Double(places))
        
        return String(format: "%02d:%02d,%01d",
                      minutes,
                      Int(truncating: NSNumber(value: seconds)),
                      Int(Double(decimalSeconds).rounded()))
    }
    
}
