//
//  ProfileHeaderViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/5/24.
//

import Foundation
import Combine
import FirebaseAuth

// TODO: Look into @MainActor
@MainActor
class ProfileHeaderViewModel: ObservableObject {
    @Published var user: User?
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserService
    public let uid: String

    
    init(userService: UserService, uid: String) {
        self.userService = userService
        self.uid = uid
        if (!self.userService.isCacheValid(for: self.userService.userCache)) {
            Task{ await self.fetchUsers() }          // attributes returned: username, fullname, email, uid
        } else {
            self.userService.invalidateCache(property: "user")
        }

        setupUserInformationPropertyObserver()
    }
    
    func fetchUsers() async {
        do {
            let snapshot = try await self.userService.fetchInformation(collectionName: "users", parameters: ["id": self.uid])
            try self.userService.updateCurrentUser(querySnapshot: snapshot)
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
