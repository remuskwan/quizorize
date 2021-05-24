//
//  Extensions.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import Foundation
import Combine
import SwiftUI
//
//extension Publishers {
//    // 1.
//    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
//        // 2.
//        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
//            .map { $0.keyboardHeight }
//        
//        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
//            .map { _ in CGFloat(0) }
//        
//        // 3.
//        return MergeMany(willShow, willHide)
//            .eraseToAnyPublisher()
//    }
//}
//
//extension Notification {
//    var keyboardHeight: CGFloat {
//        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
//    }
//}
