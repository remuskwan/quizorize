//
//  Extensions.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI

extension Alert {
    init(localizedError: LocalizedError) {
        self = Alert(nsError: localizedError as NSError)
    }
    init(nsError: NSError) {
        let message: Text? = {
            let message = [nsError.localizedFailureReason].compactMap({ $0 }).joined(separator: "\n\n")
            return message.isEmpty ? nil : Text(message)
        }()
        self = Alert(title: Text(nsError.localizedDescription),
                     message: message,
                     dismissButton: .default(Text("OK")))
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
