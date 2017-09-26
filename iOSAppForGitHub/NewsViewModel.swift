//
//  NewsViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 07/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import RxOptional
import Moya_ObjectMapper


public protocol NewsViewModelType {
    func getEvents(of user: String) -> Driver<RequestResult<[Event]>>
}

public struct NewsViewModel: NewsViewModelType {
    
    private var provider = GitHubApi.sharedProviderInstance
    
    public func getEvents(of user: String) -> SharedSequence<DriverSharingStrategy, RequestResult<[Event]>> {
        return provider.request(.events(user))
            .filterSuccessfulStatusCodes()
            .mapArray(Event.self)
            .map { .Success($0) }
            .asDriver(onErrorRecover: { error in
                return .just(.Error(ReqestError(description: error.localizedDescription, code: .requestError)))
            })
    }
}
