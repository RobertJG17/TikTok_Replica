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
        Task { await fetchUsers() }                     // attributes returned: username, fullname, email, uid
        setupUserInformationPropertyObserver()
    }
    
    func fetchUsers() async {
        do {
            try await userService.fetchInformation(collectionName: "users", field: "id")
        } catch {
            print("Error when running fetch: ", error)
        }
    }
    
    // setting up subscriber to UserService() userInformation variable
    private func setupUserInformationPropertyObserver() {
        userService.$userInformation.sink { [weak self] info in
            self?.userInformation = info
        }.store(in: &cancellables)
    }
}
