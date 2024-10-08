//
//  ExploreViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/6/24.
//

import Foundation
import Combine

@MainActor
class ExploreViewModel: ObservableObject {
    // MARK: Published property we want to attach to UserService published property
    @Published var userList: [User]?
    private let userService: UserService
    private var cancellables = Set<AnyCancellable>()


    init(userService: UserService) {
        self.userService = userService
        if (!self.userService.isCacheValid(for: userService.userListCache)) {
            Task{ await self.fetchUserList() }
        } else {
            self.userService.invalidateCache(property: "userList")
        }
        
        setupUserListPropertyObserver()
    }
    
    func fetchUserList() async {
        do {
            let snapshot = try await self.userService.fetchInformation(collectionName: "users", parameters: nil)
            try self.userService.updateUserList(querySnapshot: snapshot)
        } catch {
            print(error)
        }
    }
    
    // MARK: Sets up a Combine subscription to observe changes to the userList property in userService
    private func setupUserListPropertyObserver() {
        userService.$userList.sink { [weak self] list in
            self?.userList = list
        }.store(in: &cancellables)
    }
    /*
        MARK: 
        Whenever userService.$userList publishes a new value
        (i.e., when userList changes in userService), the sink closure is triggered.
        It updates the local userList property of the current object (self) with the new value.
    */
}
