//
//  RegistrationView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/28/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullName: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var validatePassword: String = ""
    @State private var invalidPasswords: Bool = false
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
                    .modifier(StandardTextFieldModifier(displayErrorBorder: false))
                TextField("Username", text: $userName)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier(displayErrorBorder: false))
                TextField("Enter your email", text: $email)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier(displayErrorBorder: false))
                SecureField("Enter your password", text: $password)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier(displayErrorBorder: invalidPasswords))
                SecureField("Re-enter your password", text: $validatePassword)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier(displayErrorBorder: invalidPasswords))
                // change between standard and error based on how boolean in Login Button handler is resolved
            }
            
            Text("Mismatching passwords")
                .foregroundStyle(Color.red)
                .fontWeight(.light)
                .font(.footnote)
                .opacity(invalidPasswords ? 1 : 0)
            
            // login button
            Button {
                print("DEBUG: Sign UP")
                invalidPasswords = InvalidPasswordsHelper(password: password, validatePassword: validatePassword)
                
                if !invalidPasswords {
                    // add user to firebase
                }
            } label: {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .frame(width: 350, height: 44)
            .background(.pink)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.vertical)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1: 0.7)
            
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
        .navigationBarBackButtonHidden()
    }
}

func InvalidPasswordsHelper(password: String, validatePassword: String) -> Bool {
    let passwordsMatch = password == validatePassword
    var invalidPasswords: Bool
    
    if passwordsMatch {
        // disable error border
        invalidPasswords = false
    } else {
        // enable error border
        invalidPasswords = true
    }
    
    return invalidPasswords
}


// MARK: AuthenticationFormProtocol
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !fullName.isEmpty
        && !userName.isEmpty 
        && !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && !validatePassword.isEmpty
    }
}

#Preview {
    RegistrationView()
}
