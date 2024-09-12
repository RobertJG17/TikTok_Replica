//
//  ContentViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 7/9/24.
//

import FirebaseAuth
import Firebase
import Combine
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    private var authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService) {
        self.authService = authService
        setupSubscribers()
    }
    
    // using combine allows us to call this function once and
    // listen for changes published to authService.userSession
    // Once these changes are published, the userSession variable here
    // will update the routing logic for the views.
    private func setupSubscribers() {
        authService.$userSession.sink { [weak self] user in
            self?.userSession = user
        }.store(in: &cancellables)
    }
}
