//
//  GitHubAPI.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 03/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import MoyaSugar
import Moya_ObjectMapper

public enum GitHubApi {
    case userProfile(String)
    case userProfileAvatar(String)
    case followers(String)
    case following(String)
    case userRepositories(String)
    case branches(String, Bool)
    case repositories(String)
    case events(String)
    case subscriptions(String)
}

extension GitHubApi: SugarTargetType {
    public var task: Task { return .request }
    
    public var baseURL: URL { return URL(string: Constants.API.baseGitHubUrl)! }
    
    public var url: URL {
        switch self {
        case .userProfileAvatar(let urlString):
            return URL(string: urlString)!
        default:
            return self.defaultURL
        }
    }
    
    public var route: Route {
        switch self {
        case .userProfile(let name):
            return .get("/users/\(name.urlEscaped)")
            
        case .userProfileAvatar(let url):
            return .get(url)
            
        case .userRepositories(let name):
            return .get("/users/\(name.urlEscaped)/repos")
            
        case .branches(let repo, _):
            return .get("/repos/\(repo.urlEscaped)/branches")
            
        case .repositories(_):
            return .get("/search/repositories")
            
        case .followers(let username):
            return .get("users/\(username.urlEscaped)/followers")
            
        case .following(let username):
            return .get("users/\(username.urlEscaped)/following")
        
        case .events(let userName):
            return .get("users/\(userName.urlEscaped)/events")
            
        case .subscriptions(let username):
            return .get("users/\(username.urlEscaped)/subscriptions")
        }
    }
    
    public var params: Parameters? {
        switch self {
        case .userRepositories:
            return ["sort": "pushed"]
        case .branches(_, let protected):
            return ["protected": "\(protected)"]
        case .repositories(let repoName):
            return ["q": repoName, "sort": "pushed"]
        default:
            return nil
        }
    }
    
    public var httpHeaderFields: [String: String]? {
        switch self {
        case .userProfileAvatar(_):
            return nil
        default:
            return [
                "Accept": Constants.API.acceptHeader,
                "X-RateLimit-Remaining": "100"
            ]
        }
    }
    
    
    public var sampleData: Data {
        return Data()
//        switch self {
//        case .userProfile(let name):
//            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
//        case .userRepositories:
//            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
//        case .branches:
//            return "[{\"name\": \"master\"}]".data(using: String.Encoding.utf8)!
//        }
    }
}

extension GitHubApi {
    static let sharedProviderInstance: RxMoyaSugarProvider<GitHubApi> = {
        RxMoyaSugarProvider<GitHubApi>()
    }()
}
