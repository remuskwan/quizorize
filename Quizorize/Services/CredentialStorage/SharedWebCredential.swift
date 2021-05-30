//
//  SharedWebCredential.swift
//  Quizorize
//
//  Created by Remus Kwan on 31/5/21.
//

import Foundation

enum SharedWebCredentialError: Error {
  case SecRequestFailure(CFError)
  case MissingCredentials
  case ConversionFailure
}

struct SharedWebCredential {
  private let domain: CFString
  private let safeForTutorialCode: Bool

  init(domain: String) {
    self.domain = domain as CFString
    safeForTutorialCode = !domain.isEmpty
  }

  func retrieve(account: String? = nil, completion: @escaping (Result<(account: String?, password: String?), SharedWebCredentialError>) -> Void) {
    guard safeForTutorialCode else {
      print("Please set your domain for SharedWebCredential constructor in UserAndPassword.swift!")
      return
    }

    var acct: CFString? = nil

    if let account = account {
      acct = account as CFString
    }

    SecRequestSharedWebCredential(domain, acct) { credentials, error in
      if let error = error {
        DispatchQueue.main.async {
          completion(.failure(.SecRequestFailure(error)))
        }

        return
      }

      guard
        let credentials = credentials,
        CFArrayGetCount(credentials) > 0
        else {
          DispatchQueue.main.async {
            completion(.failure(.MissingCredentials))
          }
          
          return
      }

      let unsafeCredential = CFArrayGetValueAtIndex(credentials, 0)
      let credential: CFDictionary = unsafeBitCast(unsafeCredential, to: CFDictionary.self)
      guard let dict = credential as? Dictionary<String, String> else {
        DispatchQueue.main.async {
          completion(.failure(.ConversionFailure))
        }

        return
      }

      let username = dict[kSecAttrAccount as String]
      let password = dict[kSecSharedPassword as String]

      DispatchQueue.main.async {
        completion(.success((username, password)))
      }
    }
  }

  private func update(account: String, password: String?, completion: @escaping (Result<Bool, SharedWebCredentialError>) -> Void) {
    guard safeForTutorialCode else {
      print("Please set your domain for SharedWebCredential constructor in UserAndPassword.swift!")
      return
    }

    var pwd: CFString? = nil
    if let password = password {
      pwd = password as CFString
    }

    SecAddSharedWebCredential(domain, account as CFString, pwd) { error in
      DispatchQueue.main.async {
        if let error = error {
          completion(.failure(.SecRequestFailure(error)))
        } else {
          completion(.success(true))
        }
      }
    }
  }

  func store(account: String, password: String, completion: @escaping (Result<Bool, SharedWebCredentialError>) -> Void) {
    update(account: account, password: password, completion: completion)
  }

  func delete(account: String, completion: @escaping (Result<Bool, SharedWebCredentialError>) -> Void) {
    update(account: account, password: nil, completion: completion)
  }
}
