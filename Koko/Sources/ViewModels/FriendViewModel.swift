//
//  FriendViewModel.swift
//  Koko
//
//  Created by 顏家揚 on 2023/11/7.
//

import Foundation

enum ActionStatus: CaseIterable {
    case noFriends, hasFriendsWithoutInvitations, hasFriendsAndInvitations
    var apiUrl: [String] {
        switch self {
        case .noFriends:
            return ["https://dimanyen.github.io/friend4.json"]
        case .hasFriendsWithoutInvitations:
            return ["https://dimanyen.github.io/friend1.json",  "https://dimanyen.github.io/friend2.json"]
        case .hasFriendsAndInvitations:
            return ["https://dimanyen.github.io/friend3.json"]
        }
    }
    var message: String {
        switch self {
        case .noFriends:
            return "無朋友"
        case .hasFriendsWithoutInvitations:
            return "有朋友無邀請"
        case .hasFriendsAndInvitations:
            return "有朋友有邀請"
        }
    }
}

class FriendViewModel {
    var status: ActionStatus = .noFriends
    var friends = [FriendModel]()
    var filteredFriends = [FriendModel]()
    var users = [UserModel]()
    func fetchFriends(urlString: String, completion:@escaping (Result<FriendResponse, Error>) -> Void) {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: URL(string:urlString)!)
                    let friendModel = try JSONDecoder().decode(FriendResponse.self, from: data)
                    completion(.success(friendModel))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func getUsers(completion:@escaping () -> Void){
        let urlString = "https://dimanyen.github.io/man.json"
        NetWorkManager.fetchUser(urlString: urlString) { users, error in
            if let users {
                self.users = users
                completion()
            }
        }
    }
    
    func fetchFriendsFromMultipleAPIs(completion: @escaping (Result<Void, Error>) -> Void) {
        friends.removeAll()
        let dispatchGroup = DispatchGroup()
        status.apiUrl.forEach { url in
            dispatchGroup.enter()
            self.fetchFriends(urlString: url) { result in
                switch result {
                case .success(let friends):
                    let mfriends = self.changeDateFormat(friendModel: friends.response)
                    self.addFriendsIntoViewModel(friends: mfriends)
                    dispatchGroup.leave()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            dispatchGroup.wait()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.filteredFriends = self.friends
            completion(.success(()))
        }
    }
    func changeDateFormat(friendModel: [FriendModel]) -> [FriendModel] {
        var formattedFriendModel = friendModel
        for index in 0..<formattedFriendModel.count {
            formattedFriendModel[index].updateDate.removeAll { character in
                character == "/"
            }
        }
        return formattedFriendModel
    }
    
    func addFriendsIntoViewModel(friends: [FriendModel]) {
        //過濾fid
        self.friends.append(contentsOf: friends.filter { friend in
            !self.friends.contains { friendInViewModel in
                friendInViewModel.fid == friend.fid
            }
        })
    }
}
