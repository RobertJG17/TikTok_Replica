//
//  LoginView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/28/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var invalidEmailPassword = false
    @StateObject var viewModel = LoginViewModel(authService: AuthService())
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // logo image
                Image("tik-tok-icon") // need to acquire 1024 x 1024 logo image of tik tok
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 1)
                
                // text fields
                VStack {
                    TextField("Enter your email", text: $email)
                        .textInputAutocapitalization(.never)
                        .modifier(StandardTextFieldModifier(displayErrorBorder: invalidEmailPassword))
                    SecureField("Enter your password", text: $password)
                        .textInputAutocapitalization(.never)
                        .modifier(StandardTextFieldModifier(displayErrorBorder: invalidEmailPassword))
                }
                
                // MARK: Create Milestone for forgot password functionality -- Course says can initiate a flow through firebase for functionality
                NavigationLink {
                    Text("Forgot password")
                } label: {
                    Text("Forgot Password")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Text("Invalid credentials")
                    .foregroundStyle(Color.red)
                    .fontWeight(.light)
                    .font(.footnote)
                    .opacity(invalidEmailPassword ? 1 : 0)
                
                // login button
                Button {
                    Task {
                        await viewModel.login(withEmail: email, password: password)
                    }
                    
                    // firebase authentication
                    
                    // success -> sign in
                    
                    // failure -> display red border
                    invalidEmailPassword = true
                    
                } label: {
                    Text("Login")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 350, height: 44)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.vertical)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1: 0.7)
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .padding(.vertical)
                }
                
                
                // go to sign up hyperlink
            }
        }
        // MARK: Modifier should actually act on the view with the back button displayed -> Registration view
         // .navigationBarBackButtonHidden()
    }
}


// MARK: AuthenticationFormProtocol
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty 
        && email.contains("@")
        && !password.isEmpty
    }
}

#Preview {
    LoginView()
}
