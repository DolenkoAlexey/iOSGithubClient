//
//  UserViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 03/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa
import RxOptional
import Moya_ObjectMapper

public protocol UserViewModelType {
    func getUser(by login: String) -> Driver<RequestResult<User>>
    func getUserAvatar(by avatarUrl: String) -> Driver<RequestResult<Image?>>
    func followViewModel(for endpoint: GitHubApi) -> FollowViewModelType
}

public struct UserViewModel: UserViewModelType {
    fileprivate var provider = GitHubApi.sharedProviderInstance
    
    public func getUser(by login: String) -> Driver<RequestResult<User>> {
        return provider
            .request(.userProfile(login))
            .filterSuccessfulStatusCodes()
            .mapObject(User.self)
            .map { .Success($0) }
            .asDriver(onErrorRecover: { error in
                let error = (error as? MoyaError)?.response?.statusCode == 404
                    ? ReqestError(description: "User \(login) not found", code: .notFound)
                    : ReqestError(description: error.localizedDescription, code: .requestError)
                return .just(.Error(error))
            })
    }
    
    public func getUserAvatar(by avatarUrl: String) -> Driver<RequestResult<Image?>> {
        return provider
            .request(.userProfileImage(avatarUrl))
            .mapImage()
            .map { .Success($0) }
            .asDriver(onErrorRecover: { .just(.Error(ReqestError(description: $0.localizedDescription,  code: .requestError))) })
    }
    
    public func followViewModel(for endpoint: GitHubApi) -> FollowViewModelType {
        return FollowViewModel(userViewModel: self, endpoint: endpoint)
    }
}
