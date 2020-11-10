//
//  CKErrorNotification.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 10/11/20.
//

import Foundation

enum CKErrorNotification: String {
    case userNotAuthenticated
    case networkFailure
    case networkUnavailable
    case storageQuotaExceeded
    case partialFailure
    case serviceUnavailable
    case shouldRetryRequest
}
