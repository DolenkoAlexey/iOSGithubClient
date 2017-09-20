//
//  SubscriptionsViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 20/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import RxOptional
import Moya_ObjectMapper


public protocol SubscriptionViewModelType {
    func getSubscriptions(of user: String) -> Driver<RequestResult<[Subscription]>>
    func getUserAvatar(by avatarUrl: String) -> Driver<RequestResult<Image?>>
}

public struct SubscriptionViewModel: SubscriptionViewModelType {
    private var provider = GitHubApi.sharedProviderInstance
    private let userViewModel: UserViewModelType
    
    init(userViewModel: UserViewModelType) {
        self.userViewModel = userViewModel
    }

    public func getSubscriptions(of userName: String) -> Driver<RequestResult<[Subscription]>> {
        return provider.request(.subscriptions(userName))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapArray(Subscription.self)
            .map { .Success($0) }
            .asDriver(onErrorRecover: { error in
                return .just(.Error(ReqestError(description: error.localizedDescription, code: .requestError)))
            })
            
    }
    
    public func getUserAvatar(by avatarUrl: String) -> Driver<RequestResult<Image?>> {
        return userViewModel.getUserAvatar(by: avatarUrl)
    }
}
