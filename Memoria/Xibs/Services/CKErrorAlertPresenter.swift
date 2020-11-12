//
//  CKErrorAlertPresentation.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 11/11/20.
//

import Foundation
import UIKit

protocol CKErrorAlertPresentaterDelegate: AnyObject {
    func presentAlert(_ alert: UIAlertController)
    func retryRequest()
}

class CKErrorAlertPresenter {
    
    var delegate: CKErrorAlertPresentaterDelegate // colocar weak
    
    init(viewController: CKErrorAlertPresentaterDelegate) {
        self.delegate = viewController
    }
    
    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(delegate, selector: #selector(self.networkNotResponding), name: NSNotification.Name(rawValue: CKErrorNotification.networkNotResponding.rawValue), object: nil)
        notificationCenter.addObserver(delegate, selector: #selector(self.userNotAuthenticated), name: NSNotification.Name(rawValue: CKErrorNotification.userNotAuthenticated.rawValue), object: nil)
        notificationCenter.addObserver(delegate, selector: #selector(self.storageQuotaExceeded), name: NSNotification.Name(rawValue: CKErrorNotification.storageQuotaExceeded.rawValue), object: nil)
        notificationCenter.addObserver(delegate, selector: #selector(self.serviceUnavailable), name: NSNotification.Name(rawValue: CKErrorNotification.serviceUnavailable.rawValue), object: nil)
        notificationCenter.addObserver(delegate, selector: #selector(self.retryRequest), name: NSNotification.Name(rawValue: CKErrorNotification.shouldRetryRequest.rawValue), object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(delegate, name: NSNotification.Name(rawValue: CKErrorNotification.userNotAuthenticated.rawValue), object: nil)
        notificationCenter.removeObserver(delegate, name: NSNotification.Name(rawValue: CKErrorNotification.storageQuotaExceeded.rawValue), object: nil)
        notificationCenter.removeObserver(delegate, name: NSNotification.Name(rawValue: CKErrorNotification.serviceUnavailable.rawValue), object: nil)
        notificationCenter.removeObserver(delegate, name: NSNotification.Name(rawValue: CKErrorNotification.shouldRetryRequest.rawValue), object: nil)
    }
    
    @objc func networkNotResponding(_ notification: Notification) {
        let alert = AlertManager().makePoorNetworkConnectionAlert()
        self.delegate.presentAlert(alert)
    }
    
    @objc func userNotAuthenticated(_ notification: Notification) {
        self.delegate.presentAlert(AlertManager().userNotAuthenticated)
    }
    
    @objc func storageQuotaExceeded(_ notification: Notification) {
        self.delegate.presentAlert(AlertManager().storageQuotaExceeded)
    }
    
    @objc func serviceUnavailable(_ notification: Notification) {
        self.delegate.presentAlert(AlertManager().serviceUnavailable)
    }
    
    @objc func retryRequest() {
        self.delegate.retryRequest()
    }
}
