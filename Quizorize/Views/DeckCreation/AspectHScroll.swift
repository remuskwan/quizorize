//
//  AspectHScroll.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 8/6/21.
//

import SwiftUI

struct AspectHScroll<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items) { item in
                        content(item)
                            .frame(idealWidth: fullView.size.width * 0.7, maxWidth: fullView.size.width)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
            .background(Color.white)
            
            Spacer(minLength: 0)
            
        }
    }
}

/*
struct AspectHScroll_Previews: PreviewProvider {
    static var previews: some View {
        AspectHScroll()
    }
}
*/
