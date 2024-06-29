//
//  RegistrationView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/28/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullName = ""
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var validatePassword = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // logo image
            Image("tik-tok-icon") // need to acquire 1024 x 1024 logo image of tik tok
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.bottom)
            
            // text fields
            VStack {
                TextField("Full name", text: $fullName)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier())
                TextField("Username", text: $userName)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier())
                TextField("Enter your email", text: $email)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier())
                SecureField("Enter your password", text: $password)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier())
                SecureField("Re-enter your password", text: $validatePassword)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier())
            }
            
            
            // login button
            Button {
                print("DEBUG: LOGIN")
                
                // add user to firebase user schema
            } label: {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 350, height: 44)
                    .background(.pink)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                .padding(.vertical)
            }
        }
    }
}


#Preview {
    RegistrationView()
}
