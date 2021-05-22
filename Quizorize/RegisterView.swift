//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI

struct RegisterView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var country: String = ""
        
    var body: some View {
        VStack {
            TextField("Email Address", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
            
            TextField("", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
            
            TextField("Email Address", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
