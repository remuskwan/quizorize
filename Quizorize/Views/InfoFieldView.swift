//
//  InfoFieldView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 24/5/21.
//

import SwiftUI

//MARK: InformationField Creator View
struct InfoFieldView: View {
    
    @ObservedObject var InfoType: InfoFieldViewModel
    
    @State var color = Color.black.opacity(0.7)
    @State var visible: Bool = false

    let queryCommand: String

    var body: some View {
        if InfoType.isSensitive {
            HStack(spacing: 15) {
                VStack {
                    if self.visible {
                        TextField(self.queryCommand, text: self.$InfoType.userInput)
                    } else {
                        SecureField(self.queryCommand, text: self.$InfoType.userInput)
                    }
                }
                
                Button(action: {
                    self.visible.toggle()
                }
                , label: {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                })
            }
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .background(Color(.secondarySystemBackground))
        } else {
            TextField(queryCommand, text: $InfoType.userInput)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
        }
    }
    
}

struct InfoFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InfoFieldView(InfoType: InfoFieldViewModel.Example, queryCommand: "Hi")
    }
}
