//
//  ExtendedDivider.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 27/5/21.
//

import SwiftUI

struct ExtendedDivider: View {
    let color: Color = .black
    let height: CGFloat = 1
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: self.height)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct ExtendedDivider_Previews: PreviewProvider {
    static var previews: some View {
        ExtendedDivider()
    }
}
