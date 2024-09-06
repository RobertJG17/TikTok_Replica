//
//  ProfileHeaderViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/5/24.
//

import Foundation
import Combine


@MainActor
class ProfileHeaderViewModel: ObservableObject {
    @Published var userInformation: User?
        
    private let userService = UserService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task { await userService.fetchUserInformation() }
        setupUserInformationPropertyObserver()
    }
    
    // using combine allows us to call this function once and
    // listen for changes published to userService.userInformation
    // Once these changes are published, the userSession variable here
    // will update the routing logic for the views.
    private func setupUserInformationPropertyObserver() {
        userService.$userInformation.sink { [weak self] info in
            self?.userInformation = info
        }.store(in: &cancellables)
    }
}
