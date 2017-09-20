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
import RxOptional
import RxSwift

class UserViewController: UIViewController {
    
    @IBOutlet weak var userMenuTableView: UIView!
    @IBOutlet weak var followPanel: UIStackView!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!

    var viewModel: UserViewModelType!
    private let disposeBag = DisposeBag()

    var userName: Driver<String>!
    
    lazy var user: Driver<User?> = {
            return self.userName
                .flatMapLatest { userName in self.viewModel.getUser(by: userName) }
                .map { [weak self] userResult -> User? in
                    switch userResult {
                    case .Success(let user):
                        return user
                    case .Error(let error):
                        if error.code != .notFound {
                            UIAlertController.showErrorAlert(error.description, context: self)
                        }
                        
                        return nil
                    }
                }
        }()
    
    lazy var userAvatar: Driver<Image?> = {
            self.user.filterNil()
                .flatMapLatest { user -> Driver<RequestResult<Image?>> in
                    guard let avatarUrl = user.avatarUrl else {
                        return .just(.Success(UIImage(named: Constants.ImageNames.userNotFound)))
                    }
                    
                    return self.viewModel.getUserAvatar(by: avatarUrl)
                }
                .map { result -> Image? in
                    switch result {
                    case .Success(let image):
                        return image
                    case .Error(_):
                        return nil
                    }
                }
        }()
    
    private var currentUserName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.drive(onNext: { self.currentUserName = $0 }).addDisposableTo(disposeBag)
        setupUIBindings()
    }
    
    private func setupUIBindings() {
        userAvatar.drive(onNext: { image in
                self.userProfileImage.image = image
            }).addDisposableTo(disposeBag)
        
        user.drive(onNext: { user in
                if user != nil {
                    self.set(user: user!)
                } else {
                    self.setNotFoundUser()
                }
            }).addDisposableTo(disposeBag)
        
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
            
            userMenu.user = user.filterNil()
            userMenu.userImage = userAvatar
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

