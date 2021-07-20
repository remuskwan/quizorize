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
    case wrongProvider(provider: String)
    case userNotVerified
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .wrongPassword:
            return "Invalid password"
        case .invalidEmail:
            return "Invalid email address"
        case .wrongProvider:
            return "Account created using different provider"
        case .userNotVerified:
            return "Email address not verified"
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
        case .wrongProvider(let provider):
            return "You previously created an account on Quizorize with \(provider). Please sign in with \(provider)."
        case .userNotVerified:
            return "Please verify your email address."
        default:
            return "Unknown error occured"
        }
    }
}

enum SignUpError: AuthError {
    case emailAlreadyInUse
    case emailInUseByDifferentProvider(provider: String)
    case invalidEmail
    case userNotVerified
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:
            return "Email address already in use"
        case .emailInUseByDifferentProvider:
            return "Email address in use by different provider"
        case .invalidEmail:
            return "Invalid email address"
        case .userNotVerified:
            return "Email address not verified"
        default:
            return "Unknown error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .emailAlreadyInUse:
            return "The email address you entered is already in use. Please use a different email address."
        case .emailInUseByDifferentProvider(let provider):
            return "You previously created an account on Quizorize with \(provider). Please sign in with \(provider)."
        case .invalidEmail:
            return "The email address you entered doesn't appear to belong to an account. Please check your email address and try again."
        case .userNotVerified:
            return "Please verify your email address before signing in to your new account."
        default:
            return "Unknown error occured"
        }
    }
}

enum EmailVerificationError: AuthError {
    case userNotFound
    case tooManyRequests
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Invalid email address"
        case .tooManyRequests:
            return "Too many requests"
        }
        
    }
    
    var failureReason: String? {
        switch self {
        case .userNotFound:
            return "The email address you entered doesn't exist. Please try again."
        case .tooManyRequests:
            return "too many requests sent"
        }
    }
}

enum UpdateProfileError: AuthError {
    case emailInUseByDifferentProvider(provider: String)
//    case requiresRecentLogin
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emailInUseByDifferentProvider:
            return "Email or password cannot be changed"
//        case .requiresRecentLogin:
//            return "Account created using different provider"
        default:
            return "Unknown error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .emailInUseByDifferentProvider(let provider):
            return "Your email or password cannot be changed as your account was created with \(provider)."
        default:
            return "Unknown error occured"
        }
    }
}

enum ValidateCredentialError: AuthError {
    case emailPoorlyFormatted
    case passwordPoorlyFormatted
    case passwordsDoNotMatch
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emailPoorlyFormatted:
            return "Email poorly formatted"
        case .passwordPoorlyFormatted:
            return "Password poorly formatted"
        case .passwordsDoNotMatch:
            return "Passwords do not match"
        default:
            return "Unknown error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .emailPoorlyFormatted:
            return "Enter a valid email address."
        case .passwordPoorlyFormatted:
            return "Passwords must be between 8 and 15 characters and contain at least one number and one capital letter."
        default:
            return "Unknown error"
        }
    }
}
