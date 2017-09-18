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
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    private var userName: Driver<String> {
        return searchBar.rx.text
            .orEmpty
            .asDriver()
            .throttle(1)
            .distinctUntilChanged()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTranslucency()
        setupUIBindings()
    }
    
    private func setTranslucency() {
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
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
                    self.setUser(for: user)
                    
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
    
    private func setUser(for user: User) {
        self.loginLabel.text = user.login ?? ""
        self.followersCountLabel.text = user.followersCount ?? ""
        self.followingCountLabel.text = user.followingCount ?? ""
        self.userMenuTableView.isHidden = false
        self.title = user.login
    }
    
    private func setNotFoundUser() {
        self.userMenuTableView.isHidden = true
        self.loginLabel.text = "User not found"
        self.title = "User"
        self.followersCountLabel.text = "---"
        self.followingCountLabel.text = "---"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.userMenuEmbed,
            let userMenu = segue.destination as? UserMenuTableViewController {
            
            userMenu.userNameDriver = userName
        }
    }
}

