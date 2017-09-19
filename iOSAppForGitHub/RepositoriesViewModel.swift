//
//  RepositoriesViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 08/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import MoyaSugar
import Moya
import RxCocoa
import RxSwift
import RxOptional
import Moya_ObjectMapper

public protocol RepositoriesViewModelType {
    func getRepositories(destination: GitHubApi) -> Driver<RequestResult<[Repository]>>
}

public struct RepositoriesViewModel: RepositoriesViewModelType {
    fileprivate var provider = GitHubApi.sharedProviderInstance
    
    public func getRepositories(destination: GitHubApi) -> Driver<RequestResult<[Repository]>> {
        return provider.request(destination)
            .filterSuccessfulStatusCodes()
            .mapRepositories(destination: destination)
            .map { .Success($0) }
            .asDriver(onErrorRecover: { error in
                return .just(.Error(ReqestError(description: error.localizedDescription, code: .requestError)))
            })
    }
}

private extension Observable where E == Response {
    func mapRepositories(destination: GitHubApi) -> Observable<[Repository]> {
        let repositories: Observable<[Repository]>
        
        switch destination {
        case .repositories(_):
            repositories = self.mapObject(Repositories.self).map { $0.repositories ?? [] }
        case .userRepositories(_):
            repositories = self.mapArray(Repository.self)
        default:
            fatalError("Unexpected request type \"\(destination)\"")
        }

        return repositories
    }
}
