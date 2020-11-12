//
//  CKErrorNotification.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 10/11/20.
//

import Foundation

enum CKErrorNotification: String {
    case userNotAuthenticated
    case networkNotResponding
    case storageQuotaExceeded
    case serviceUnavailable
    case shouldRetryRequest
}
