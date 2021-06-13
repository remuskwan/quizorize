//
//  SearchView.swift
//  Quizorize
//
//  Created by Remus Kwan on 1/6/21.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        Search()
    }
}

struct Search: View {
    var body: some View {
        NavigationView {
            ScrollView {}
                .navigationTitle("Search")
        }
    }
    
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
