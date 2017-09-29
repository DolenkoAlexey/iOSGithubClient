//
//  FileSourceViewModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 29/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import RxOptional
import Moya_ObjectMapper

public protocol FileSourceViewModelType {
    var error: Driver<ReqestError> { get }
    func getContent() -> Driver<FileContent>
}

public struct FileSourceViewModel: FileSourceViewModelType {
    private var provider = GitHubApi.sharedProviderInstance
    private let errorVariable: Variable<ReqestError?>
    private let repository: Repository
    private let path: String
    public let error: Driver<ReqestError>
    
    init(repository: Repository, path: String) {
        self.errorVariable = Variable<ReqestError?>(nil)
        self.error = self.errorVariable.asDriver().filterNil()
        self.repository = repository
        self.path = path
    }
    
    public func getContent() -> Driver<FileContent> {
        guard let repositoryName = repository.name,
            let usernamename = repository.owner?.login
            else {
                fatalError("Repository name and owner cannot be nil")
        }
        
        return provider.request(.repositoryContent(usernamename, repositoryName, self.path))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(FileContent.self)
            .map { .Success($0) }
            .asDriver(onErrorRecover: { error -> Driver<RequestResult<FileContent>> in
                return .just(.Error(ReqestError(description: error.localizedDescription, code: .requestError)))
            })
            .map { contentResult -> FileContent? in
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
