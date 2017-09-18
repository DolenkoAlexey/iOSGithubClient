//
//  Result.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 11/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

public struct ReqestError {
    let description: String
    let code: Code
    
    enum Code: Int {
        case requestError = 400
        case notFound = 404
    }
   
}

public enum RequestResult<Value> {
    case Success(Value)
    case Error(ReqestError)
}
