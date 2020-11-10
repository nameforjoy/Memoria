//
//  ErrorHandling.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 10/11/20.
//

import Foundation
import CloudKit

class CKErrorHandling {
    
    static func treatCKErrors(ckError: CKError) -> Void {
        if ckError.code == CKError.requestRateLimited {
            let retryInterval = ckError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
            }
        } else if ckError.code == CKError.zoneBusy {
            let retryInterval = ckError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
            }
        } else if ckError.code == CKError.limitExceeded {
            let retryInterval = ckError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
            }
        } else if ckError.code == CKError.notAuthenticated {
            NotificationCenter.default.post(name: Notification.Name("noCloud"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.networkFailure {
            NotificationCenter.default.post(name: Notification.Name("networkFailure"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.networkUnavailable {
            NotificationCenter.default.post(name: Notification.Name("noWiFi"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.quotaExceeded {
            NotificationCenter.default.post(name: Notification.Name("quotaExceeded"), object: nil, userInfo: nil)
        } else if ckError.code == CKError.partialFailure {
            NotificationCenter.default.post(name: Notification.Name("partialFailure"), object: nil, userInfo: nil)
        } else if (ckError.code == CKError.internalError || ckError.code == CKError.serviceUnavailable) {
            NotificationCenter.default.post(name: Notification.Name("serviceUnavailable"), object: nil, userInfo: nil)
        }
    }
    
    @objc func files_saveNotes() {
        
    }
}
