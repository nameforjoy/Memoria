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
    static func treatCKErrors(ckError: CKError) {
        
        if ckError.code == CKError.zoneBusy ||
            ckError.code == CKError.requestRateLimited ||
            ckError.code == CKError.limitExceeded {
            // Send notification to retry performimg request after some time
            let retryInterval = ckError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.sendRetryNotification), userInfo: nil, repeats: false)
            }
        } else if ckError.code == CKError.notAuthenticated {
            NotificationCenter.default.post(name: Notification.Name(CKErrorNotification.userNotAuthenticated.rawValue), object: nil, userInfo: nil)
        } else if ckError.code == CKError.networkFailure {
            NotificationCenter.default.post(name: Notification.Name(CKErrorNotification.networkFailure.rawValue), object: nil, userInfo: nil)
        } else if ckError.code == CKError.networkUnavailable {
            NotificationCenter.default.post(name: Notification.Name(CKErrorNotification.networkUnavailable.rawValue), object: nil, userInfo: nil)
        } else if ckError.code == CKError.quotaExceeded {
            NotificationCenter.default.post(name: Notification.Name(CKErrorNotification.storageQuotaExceeded.rawValue), object: nil, userInfo: nil)
        } else if ckError.code == CKError.partialFailure {
            NotificationCenter.default.post(name: Notification.Name(CKErrorNotification.partialFailure.rawValue), object: nil, userInfo: nil)
        } else if (ckError.code == CKError.internalError || ckError.code == CKError.serviceUnavailable) {
            NotificationCenter.default.post(name: Notification.Name(CKErrorNotification.serviceUnavailable.rawValue), object: nil, userInfo: nil)
        }
    }
    
    @objc func sendRetryNotification() {
        NotificationCenter.default.post(name: Notification.Name(CKErrorNotification.shouldRetryRequest.rawValue), object: nil, userInfo: nil)
    }
}
