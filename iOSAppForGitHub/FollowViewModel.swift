//
//  FollowViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 19/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import MoyaSugar
import Moya
import RxSwift
import RxCocoa
import RxOptional
import Moya_ObjectMapper

public protocol FollowViewModelType {
    func getUsers() -> Driver<RequestResult<[User]>>
    func getUserAvatar(by avatarUrl: String) -> Driver<RequestResult<Image?>>
}

public struct FollowViewModel: FollowViewModelType {
    private let userViewModel: UserViewModelType
    private let endpoint: GitHubApi
    private var provider = GitHubApi.sharedProviderInstance
    
    init(userViewModel: UserViewModelType, endpoint: GitHubApi) {
        self.userViewModel = userViewModel
        self.endpoint = endpoint
    }
    
    public func getUsers() -> Driver<RequestResult<[User]>> {
        return provider.request(self.endpoint)
            .filterSuccessfulStatusCodes()
            .mapArray(User.self)
            .map { .Success($0) }
            .asDriver(onErrorJustReturn: .Success([]))
    }
    
    public func getUserAvatar(by avatarUrl: String) -> Driver<RequestResult<Image?>> {
        return userViewModel.getUserAvatar(by: avatarUrl)
    }
}
