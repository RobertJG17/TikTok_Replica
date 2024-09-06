//
//  RegistrationView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/28/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullname: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var validatePassword: String = ""
    @State private var invalidPasswords: Bool = false
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: RegistrationViewModel
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
        
        let viewModel = RegistrationViewModel(authService: authService)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
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
                TextField("Full name", text: $fullname)
                    .textInputAutocapitalization(.never)
                    .modifier(StandardTextFieldModifier(displayErrorBorder: false))
                TextField("Username", text: $username)
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
                invalidPasswords = InvalidPasswordsHelper(password: password, validatePassword: validatePassword)
                
                if !invalidPasswords {
                    print("DEBUG Registration View: Valid passwords")
                    // add user to firebase
                    Task {
                        await viewModel.createUser(withEmail: email, password: password, username: username, fullname: fullname)
                    }
                    
                    print("DEBUG Registration View: Task Completed")
                } else {
                    print("DEBUG Registration View: Invalid passwords")
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
        return !fullname.isEmpty
        && !username.isEmpty
        && !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && !validatePassword.isEmpty
    }
}

#Preview {
    RegistrationView(authService: AuthService())
}
