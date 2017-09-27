//
//  RepositoryViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 27/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

import Moya
import RxCocoa
import RxSwift
import RxOptional
import Moya_ObjectMapper

public protocol RepositoryViewModelType {
    var error: Driver<ReqestError> { get }
    var repository: Driver<Repository> { get }
    var branchesCount: Driver<Int> { get }
}

public class RepositoryViewModel: RepositoryViewModelType {
    fileprivate var provider = GitHubApi.sharedProviderInstance
    
    private let username: String
    private let projectName: String
    private let errorVariable: Variable<ReqestError?>
    public let error: Driver<ReqestError>
    
    public lazy var repository: Driver<Repository> = {
        self.getRepository()
            .map {[weak self] repository -> Repository? in
                switch repository {
                case .Success(let repo):
                    return repo
                case .Error(let error):
                    self?.errorVariable.value = error
                    return nil
                }
            }
            .filterNil()
    }()
    
    public lazy var branchesCount: Driver<Int> = {
        self.getBranches()
            .map { branches -> [Branch]? in
                switch branches {
                case .Success(let branches):
                    return branches
                case .Error(_):
                    return nil
                }
            }
            .filterNil()
            .map { $0.count }
    }()
    
    init(username: String, projectName: String) {
        self.username = username
        self.projectName = projectName
        self.errorVariable = Variable<ReqestError?>(nil)
        self.error = self.errorVariable.asDriver().filterNil()
    }
    
    private func getRepository() -> Driver<RequestResult<Repository>> {
        return provider.request(.repository(username, projectName))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(Repository.self)
            .map { .Success($0) }
            .asDriver(onErrorRecover: { error in
                return .just(.Error(ReqestError(description: error.localizedDescription, code: .requestError)))
            })
    }
    
    private func getBranches() -> Driver<RequestResult<[Branch]>> {
        return provider.request(.branches(username, projectName))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapArray(Branch.self)
            .map { .Success($0) }
            .asDriver(onErrorRecover: { error in
                return .just(.Error(ReqestError(description: error.localizedDescription, code: .requestError)))
            })
    }
}
