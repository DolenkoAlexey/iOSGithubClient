//
//  FollowTableViewCell.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 19/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class FollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.login
        }
    }
    
    var avatar: Driver<RequestResult<Image?>>! {
        didSet {
            avatar.drive(onNext: { result in
                switch result {
                case .Success(let avatar):
                    self.userAvatarImageView.image = avatar
                case .Error(let error):
                    print("Error while loading \(self.usernameLabel.text ?? "unknown"): \(error)")
                    self.userAvatarImageView.image = UIImage(named: Constants.ImageNames.userNotFound)
                }
            }).addDisposableTo(disposeBag)
        }
    }
    
    
}
