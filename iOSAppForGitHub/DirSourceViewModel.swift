//
//  SourceViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 28/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//
import Moya
import RxCocoa
import RxSwift
import RxOptional
import Moya_ObjectMapper

public protocol DirSourceViewModelType {
    var error: Driver<ReqestError> { get }
    var repository: Repository { get }
    func getContent() -> Driver<[DirContent]>
    func getContentViewModel(of path: String) -> DirSourceViewModelType
}

public struct DirSourceViewModel: DirSourceViewModelType {
    private var provider = GitHubApi.sharedProviderInstance
    private let errorVariable: Variable<ReqestError?>
    public let repository: Repository //todo encapsulate
    private let path: String
    public let error: Driver<ReqestError>
    
    init(repository: Repository, path: String = "") {
        self.errorVariable = Variable<ReqestError?>(nil)
        self.error = self.errorVariable.asDriver().filterNil()
        self.repository = repository
        self.path = path
    }
    
    public func getContentViewModel(of path: String) -> DirSourceViewModelType{
        return DirSourceViewModel(repository: repository, path: path)
    }
    
    public func getContent() -> Driver<[DirContent]> {
        guard let repositoryName = repository.name,
            let usernamename = repository.owner?.login
            else {
                fatalError("Repository name and owner cannot be nil")
        }
        
        return provider.request(.repositoryContent(usernamename, repositoryName, self.path))
                .filterSuccessfulStatusCodes()
                .asObservable()
                .mapArray(DirContent.self)
                .map { .Success($0) }
                .asDriver(onErrorRecover: { error -> Driver<RequestResult<[DirContent]>> in
                    return .just(.Error(ReqestError(description: error.localizedDescription, code: .requestError)))
                })
                .map { contentResult -> [DirContent]? in
                    switch contentResult {
                    case .Success(let content):
                        return content
                    case .Error(let error):
                        self.errorVariable.value = error
                        return nil
                    }
                }
                .filterNil()
    }
}
