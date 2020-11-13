//
//  UIViewControllerConnectivity.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 11/11/20.
//

import UIKit
import Network
import CloudKit

@objc protocol RequestRetry {
    func retryRequest()
}

extension UIViewController {
    
    func checkInternetConnectivity(monitor: NWPathMonitor, message: String? = nil) {
        // Configure completion for whenever connection status changes
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    let alert = AlertManager().makePoorNetworkConnectionAlert(message: message)
                    self.present(alert, animated: true)
                }
            }
        }
        // Start monitoring status
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    /// Show alert for errors
    func treatDBErrors(error: Error, requestRetry: RequestRetry? = nil, _ completion: @escaping (_ alert: UIAlertController) -> Void) {
        
        guard let ckError: CKError = error as? CKError else {
            completion(AlertManager().serviceUnavailable)
            return
        }
        switch ckError.code {
        case CKError.zoneBusy, CKError.requestRateLimited, CKError.limitExceeded:
            // retry performimg request after some time
            let retryInterval = ckError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(requestRetry?.retryRequest), userInfo: nil, repeats: false)
            }
        case CKError.notAuthenticated:
            completion(AlertManager().userNotAuthenticated)
        case CKError.networkFailure, CKError.networkUnavailable:
            let alert = AlertManager().makePoorNetworkConnectionAlert(message: "Não conseguimos acessar suas memórias no iCloud pois a conexão com a internet é insuficiente.")
            completion(alert)
        case CKError.quotaExceeded:
            completion(AlertManager().storageQuotaExceeded)
        default:
            completion(AlertManager().serviceUnavailable)
        }
    }
}
