////
////  DefaultLoginView.swift
////  Quizorize
////
////  Created by CHEN JUN HONG on 24/5/21.
////
//
//import SwiftUI
//
//struct DefaultLoginView: View {
//    @State var email: String = ""
//    @State var password: String = ""
//    
//    @State var color = Color.black.opacity(0.7)
//    @State var visible = false
//    
//    let frameWidth: CGFloat
//    let frameHeight: CGFloat
//    let borderWidth: CGFloat
//    let borderCornerRadius: CGFloat
//    let shadowRadius: CGFloat
//    
//    var body: some View {
//        VStack {
//            VStack {
//                TextField("Email Address", text: $email)
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .padding()
//                    .background(Color(.secondarySystemBackground))
//                
//                HStack(spacing: 15) {
//                    
//                    VStack {
//                        if self.visible {
//                            TextField("Password", text: self.$password)
//                        } else {
//                            SecureField("Password", text: $password)
//                        }
//                    }
//                    
//                    Button(action: {
//                        self.visible.toggle()
//                    }
//                    , label: {
//                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
//                            .foregroundColor(self.color)
//                    })
//                }
//                .disableAutocorrection(true)
//                .autocapitalization(.none)
//                .padding()
//                .background(Color(.secondarySystemBackground))
//                
//                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                    Text("Sign In")
//                        .font(.headline)
//                        .cornerRadius(8)
//                        .foregroundColor(.white)
//                        .frame(width: frameWidth, height: frameHeight)
//                        .background(Color.purple)
//                        .addBorder(Color.purple, width: borderWidth, cornerRadius: borderCornerRadius)
//                        .shadow(radius: 1.5)
//                })
//                .padding(4)
//                
//                NavigationLink(
//                    destination: RegisterView(),
//                    label: {
//                        Text("Register For An Account")
//                            .font(.headline)
//                            .foregroundColor(.purple)
//                            .frame(width: frameWidth, height: frameHeight)
//                            .background(Color.white)
//                            .addBorder(Color.purple, width: borderWidth, cornerRadius: borderCornerRadius)
//                            .shadow(radius: shadowRadius)
//                    })
//            }
//            .padding()
//            
//        }
//    }
//}
//
//struct DefaultLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        DefaultLoginView(frameWidth: 250, frameHeight: 100, borderWidth: 1, borderCornerRadius: 20, shadowRadius: 1.5)
//    }
//}
