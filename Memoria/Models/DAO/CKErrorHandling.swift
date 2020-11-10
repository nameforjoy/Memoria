//
//  ErrorHandling.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 10/11/20.
//

import Foundation
import CloudKit

class CKErrorHandling {
    
    /// Send notification center post for iCloud errors
    static func treatCKErrors(ckError: CKError) -> Void {
        
        if ckError.code == CKError.zoneBusy ||
            ckError.code == CKError.requestRateLimited ||
            ckError.code == CKError.limitExceeded {
            // Send notification to retry performimg request after some time
            let retryInterval = ckError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.sendRetryNotification), userInfo: nil, repeats: false)
            }
        } else if ckError.code == CKError.notAuthenticated {
            NotificationCenter.default.post(name: Notification.Name("noCloud"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.networkFailure {
            NotificationCenter.default.post(name: Notification.Name("networkFailure"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.networkUnavailable {
            NotificationCenter.default.post(name: Notification.Name("networkUnavailable"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.quotaExceeded {
            NotificationCenter.default.post(name: Notification.Name("quotaExceeded"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.partialFailure {
            NotificationCenter.default.post(name: Notification.Name("partialFailure"), object: nil, userInfo: nil)
        } else if (ckError.code == CKError.internalError || ckError.code == CKError.serviceUnavailable) {
            NotificationCenter.default.post(name: Notification.Name("serviceUnavailable"), object: nil, userInfo: nil)
        }
    }
    
    @objc func sendRetryNotification() {
        NotificationCenter.default.post(name: Notification.Name("retryRequest"), object: nil, userInfo: nil)
    }
}

enum ErrorNotificationName: String {
    case iCloudNotAuthenticated = "noCloud"
    case networkFailure = "networkFailure"
    case networkUnavailable = "networkUnavailable"
    case storageQuotaExceeded = "quotaExceeded"
    case partialFailure = "partialFailure"
    case serviceUnavailable = "serviceUnavailable"
    case shouldRetryRequest = "shouldRetryRequest"
    case notRelatedToiCloud = "notRelatedToiCloud"
}
