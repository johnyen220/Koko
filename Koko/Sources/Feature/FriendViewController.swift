//
//  FriendViewController.swift
//  Koko
//
//  Created by 顏家揚 on 2023/11/7.
//

import UIKit
import os

class FriendViewController: UIViewController {
    
    
    @IBOutlet weak var userInfoView: UserInfoView!
    let viewModel = FriendViewModel()
    var userInfoViewHeightConstraint: NSLayoutConstraint?
    var isOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActionSheet()
        loadData()
    }
    private func loadData() {
        self.viewModel.getUsers {
             self.userInfoView.updateUser(user: self.viewModel.users[0])
        }
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
fileprivate extension FriendViewController {
    private func setupNavigationBarItem(){
        let atmBarButtonItem = UIBarButtonItem(image: UIImage(named: "icNavPinkWithdraw")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), landscapeImagePhone: nil, style: .plain, target: self, action: nil)
        let transferBarButtonItem = UIBarButtonItem(image: UIImage(named: "icNavPinkTransfer")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), landscapeImagePhone: nil, style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [atmBarButtonItem, transferBarButtonItem]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icNavPinkScan")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), landscapeImagePhone: nil, style: .plain, target: self, action: nil)
    }

    func showActionSheet() {
        let controller = UIAlertController(title: "選擇狀態", message: nil, preferredStyle: .actionSheet)
        ActionStatus.allCases.forEach { status in
            let action = UIAlertAction(title: status.message, style: .default) { _ in
                self.viewModel.status = status
                self.viewModel.fetchFriendsFromMultipleAPIs { error in
                    switch error {
                        case .success():
                            self.setupFriendView()
                        case .failure(let error):
                            print(error)
                        }
                }
            }
            controller.addAction(action)
        }
        present(controller, animated: true)
    }
    
    func setupFriendView() {
        userInfoView.clearInvitationFriendsView()
        if viewModel.friends.isEmpty {
            userInfoView.updateBadge(friendBadgeNum: nil, chatBadgeNum: nil)
            showNoFriendView()
        } else {
            let invitaionFriends = viewModel.friends.filter { $0.status == 2 }
            if (!invitaionFriends.isEmpty) {
                userInfoView.showInvitaion(friends: invitaionFriends)
                userInfoView.updateBadge(friendBadgeNum: "\(invitaionFriends.count)", chatBadgeNum: "99+")
            } else {
                userInfoView.updateBadge(friendBadgeNum: nil, chatBadgeNum: "99+")
            }
            showFriendTableView()
        }
    }
    
    func showNoFriendView() {
        let noFriendView = NoFriendView()
        noFriendView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noFriendView)
        NSLayoutConstraint.activate([
            noFriendView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor),
            noFriendView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noFriendView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noFriendView.bottomAnchor.constraint(equalTo: tabBarController!.tabBar.topAnchor)
        ])
    }
    
    func showFriendTableView() {
        let friendTableView = FriendTableView(friendViewModel: viewModel)
        friendTableView.delegate = self
        friendTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(friendTableView)
        NSLayoutConstraint.activate([
            friendTableView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor),
            friendTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendTableView.bottomAnchor.constraint(equalTo: tabBarController!.tabBar.topAnchor)
        ])
    }}
// MARK: - UITableViewDelegate
extension FriendViewController: FriendTableViewDelegate {
    func searchBarTextDidBeginEditing(_ controller: FriendTableView) {

        userInfoViewHeightConstraint = userInfoView.heightAnchor.constraint(equalToConstant: 0)
        userInfoViewHeightConstraint?.isActive = true
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()})
    }
    
    func searchBarTextDidEndEditing(_ controller: FriendTableView) {
        userInfoViewHeightConstraint?.isActive = false
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()})
    }
}
