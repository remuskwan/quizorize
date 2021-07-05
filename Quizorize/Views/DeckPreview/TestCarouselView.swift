//
//  TestCarouselView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 5/7/21.
//

import SwiftUI

struct TestCarouselView: View {
    var randomAnyViews = [AnyView(Text("Hi")), AnyView(Text("Bye")), AnyView(Text("baba")), AnyView(Text("AA")), AnyView(Text("WWW"))]

    var body: some View {
        /*
        CarouselView(itemHeight: 500, views: randomAnyViews)
        */
        Text("Hi")
    }
}

struct TestCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        TestCarouselView()
    }
}
