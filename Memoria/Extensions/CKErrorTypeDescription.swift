//
//  CKErrorTypeDescription.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 24/11/20.
//

import CloudKit

extension CKError {
    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    func typeDescription() -> String {
        switch self.code {
        case .alreadyShared:
            return "already shared"
        case .assetFileModified:
            return "asset file modified"
        case .assetFileNotFound:
            return "asset file not found"
        case .assetNotAvailable:
            return "asset not available"
        case .badContainer:
            return "bad container"
        case .badDatabase:
            return "bad database"
        case .batchRequestFailed:
            return "batch request failed"
        case .changeTokenExpired:
            return "change token expired"
        case .constraintViolation:
            return "constraint violation"
        case .incompatibleVersion:
            return "incompatible version"
        case .internalError:
            return "internal error"
        case .invalidArguments:
            return "invalid arguments"
        case .limitExceeded:
            return "limit exceeded"
        case .managedAccountRestricted:
            return "managed account restricted"
        case .missingEntitlement:
            return "missing entitlement"
        case .networkFailure:
            return "network failure"
        case .networkUnavailable:
            return "network unavailable"
        case .notAuthenticated:
            return "not authenticated"
        case .operationCancelled:
            return "operation cancelled"
        case .partialFailure:
            return "partial failure"
        case .participantMayNeedVerification:
            return "participant may need verification"
        case .permissionFailure:
            return "permission failure"
        case .quotaExceeded:
            return "quota exceeded"
        case .referenceViolation:
            return "reference violation"
        case .requestRateLimited:
            return "request rate limited"
        case .serverRecordChanged:
            return "server record changed"
        case .serverRejectedRequest:
            return "server rejected request"
        case .serverResponseLost:
            return "server response lost"
        case .serviceUnavailable:
            return "service unavailable"
        case .tooManyParticipants:
            return "too many participants"
        case .unknownItem:
            return "unknown item"
        case .userDeletedZone:
            return "user deleted zone"
        case .zoneBusy:
            return "zone busy"
        case .zoneNotFound:
            return "zone not found"
        default:
            return "unknown"
        }
    }
}
