//
//  NetworkManagers.swift
//  Koko
//
//  Created by 顏家揚 on 2023/11/7.
//

import Foundation
class NetWorkManager {
    
    class func fetchFriend(urlString: String, completion:@escaping ([FriendModel]?, String?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data {
                let friendResponse = try? JSONDecoder().decode(FriendResponse.self, from: data)
                completion(friendResponse?.response, nil)
            } else {
                completion(nil, "Error")
            }
        }
        task.resume()
    }
    
    class func fetchUser(urlString: String, completion:@escaping ([UserModel]?, String?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data {
                let userResponse = try? JSONDecoder().decode(UserResponse.self, from: data)
                completion(userResponse?.response, nil)
            } else {
                completion(nil, "Error")
            }
        }
        task.resume()
    }
}

