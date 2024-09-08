//
//  ProfileHeaderViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/5/24.
//

import Foundation
import Combine
import FirebaseAuth


@MainActor
class ProfileHeaderViewModel: ObservableObject {
    @Published var user: User?
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserService
    public let uid: String
    
    init(userService: UserService, uid: String) {
        self.userService = userService
        self.uid = uid
        
        Task{ await self.fetchUsers() }             // attributes returned: username, fullname, email, uid
        
        setupUserInformationPropertyObserver()
    }
    
    func fetchUsers() async {
        do {
            try await self.userService.fetchInformation(collectionName: "users", parameters: ["id": self.uid])
        } catch {
            print(error)
        }
    }
    
    // setting up subscriber to UserService() userInformation variable
    private func setupUserInformationPropertyObserver() {
        userService.$user.sink { [weak self] info in
            self?.user = info
        }.store(in: &cancellables)
    }
}
