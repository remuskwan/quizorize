//
//  AuthErrors.swift
//  Quizorize
//
//  Created by Remus Kwan on 26/5/21.
//

import SwiftUI

protocol AuthError: LocalizedError {
    var errorDescription: String? { get }
    var failureReason: String? { get }
}

enum SignInError: AuthError {
    case wrongPassword
    case invalidEmail
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .wrongPassword:
            return "Invalid password"
        case .invalidEmail:
            return "Invalid email address"
        default:
            return "Unknown error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .wrongPassword:
            return "The password you entered was incorrect. Please try again with a different password."
        case .invalidEmail:
            return "The email address you entered doesn't appear to belong to an account. Please check your email address and try again."
        default:
            return "Unknown error occured"
        }
    }
}

enum SignUpError: AuthError {
    case emailAlreadyInUse
    case emailInUseByDifferentProvider(provider: String)
    case invalidEmail
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:
            return "Email address already in use"
        case .emailInUseByDifferentProvider:
            return "Email address in use by different provider"
        case .invalidEmail:
            return "Invalid email address"
        default:
            return "Unknown error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .emailAlreadyInUse:
            return "The email address you entered is already in use. Please use a different email address or Sign In."
        case .emailInUseByDifferentProvider(let provider):
            return "You already have an account on Quizorize. Please Sign In with \(provider)."
        case .invalidEmail:
            return "The email address you entered doesn't appear to belong to an account. Please check your email address and try again."
        default:
            return "Unknown error occured"
        }
    }
}

enum EmailVerificationError: AuthError {
    case userNotFound
    
    var errorDescription: String? {
        return "Invalid email address"
    }
    
    var failureReason: String? {
        return "The email address you entered doesn't exist. Please try again."
    }
}
