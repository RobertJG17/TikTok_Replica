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
    private let uid: String = Auth.auth().currentUser!.uid
    
    init(userService: UserService) {
        self.userService = userService
        Task{ await self.fetchUsers() }          // attributes returned: username, fullname, email, uid
        setupUserInformationPropertyObserver()
    }
    
    func fetchUsers() async {
        do {
            let snapshot = try await self.userService.fetchInformation(
                collectionName: "users",
                parameters: [
                    "id": self.uid
                ]
            )
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
