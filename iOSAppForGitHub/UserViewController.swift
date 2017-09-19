//
//  ViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 03/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift

class UserViewController: UIViewController {

    var viewModel: UserViewModelType!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var userMenuTableView: UIView!
    @IBOutlet weak var followPanel: UIStackView!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!

    var userName: Driver<String>!
    private var currentUserName: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.drive(onNext: { self.currentUserName = $0 }).addDisposableTo(disposeBag)
        setupUIBindings()
    }
    
    private func setupUIBindings() {
        userName
            .flatMapLatest { userName in
                return self.viewModel.getUser(by: userName)
            }
            .flatMapLatest { userResult -> Driver<RequestResult<Image?>> in
                let userNotFoundDriver = Driver<RequestResult<Image?>>.just(.Success(UIImage(named: Constants.ImageNames.userNotFound)))
                
                switch userResult {
                case .Success(let user):
                    self.set(user: user)
                    
                    guard let avatarUrl = user.avatarUrl else {
                        return userNotFoundDriver
                    }
                    
                    return self.viewModel.getUserAvatar(by: avatarUrl)
                case .Error(let error):
                    if error.code != .notFound {
                        UIAlertController.showErrorAlert(error.description, context: self)
                    }
                    
                    self.setNotFoundUser()
                    
                    return userNotFoundDriver
                }
                
               
            }
            .drive(onNext: { userImage in
                switch userImage {
                case .Success(let image):
                    self.userProfileImage.image = image
                case .Error(_):
                    break
                }
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func set(user: User) {
        loginLabel.text = user.login ?? ""
        followersCountLabel.text = user.followersCount ?? ""
        followingCountLabel.text = user.followingCount ?? ""
        followPanel.isHidden = false
        userMenuTableView.isHidden = false
        navigationController?.navigationBar.topItem?.title = user.login
    }
    
    private func setNotFoundUser() {
        loginLabel.text = "User not found"
        followersCountLabel.text = "---"
        followingCountLabel.text = "---"
        followPanel.isHidden = true
        userMenuTableView.isHidden = true
        navigationController?.navigationBar.topItem?.title = "User"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.userMenuEmbed,
            let userMenu = segue.destination as? UserMenuTableViewController {
            
            userMenu.userName = userName
        }
        
        if let followersViewController = segue.destination as? FollowTableViewController {
            
            if segue.identifier == Constants.SegueIdentifiers.followers {
                followersViewController.navigationItem.title = "Followers"
                followersViewController.viewModel = viewModel.followViewModel(for: .followers(currentUserName))
            }
            
            if segue.identifier == Constants.SegueIdentifiers.following {
                followersViewController.navigationItem.title = "Following"
                followersViewController.viewModel = viewModel.followViewModel(for: .following(currentUserName))
            }
        }
    }
}

