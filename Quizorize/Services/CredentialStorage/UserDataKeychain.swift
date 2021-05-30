//
//  UserDataKeychain.swift
//  Quizorize
//
//  Created by Remus Kwan on 31/5/21.
//

import Foundation

struct UserDataKeychain: Keychain {
  // Make sure the account name doesn't match the bundle identifier!
  var account = "com.raywenderlich.SignInWithApple.Details"
  var service = "userIdentifier"

  typealias DataType = UserData
}
