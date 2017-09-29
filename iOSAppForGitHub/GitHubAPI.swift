//
//  GitHubAPI.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 03/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Moya
import RxSwift

public enum GitHubApi {
    case userProfile(String)
    case userProfileImage(String)
    case followers(String)
    case following(String)
    case userRepositories(String)
    case branches(String, String)
    case repositories(String)
    case events(String)
    case subscriptions(String)
    case repository(String, String)
    case repositoryContent(String, String, String)
}

extension GitHubApi: TargetType {
    public var path: String {
        switch self {
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
            
        case .userProfileImage(_):
            return ""
            
        case .userRepositories(let name):
            return "/users/\(name.urlEscaped)/repos"
            
        case .branches(let userName, let projectName):
            return "repos/\(userName)/\(projectName)/branches"
            
        case .repositories(_):
            return "/search/repositories"
            
        case .followers(let username):
            return "users/\(username.urlEscaped)/followers"
            
        case .following(let username):
            return "users/\(username.urlEscaped)/following"
            
        case .events(let userName):
            return "users/\(userName.urlEscaped)/events"
            
        case .subscriptions(let username):
            return "users/\(username.urlEscaped)/subscriptions"
            
        case .repository(let username, let projectName):
            return "/repos/\(username.urlEscaped)/\(projectName.urlEscaped)"
            
        case .repositoryContent(let username, let projectName, let path):
            return "/repos/\(username.urlEscaped)/\(projectName.urlEscaped)/contents/\(path)"
        }
    }
    
    public var method: Moya.Method { return .get }
    
    public var headers: [String : String]? {
        switch self {
        case .userProfileImage(_):
            return nil
        default:
            return [
                "Accept": Constants.API.acceptHeader,
                "X-RateLimit-Remaining": "100"
            ]
        }
    }
    
    public var task: Task {
        switch self {
        case .userRepositories:
            return .requestParameters(parameters: ["sort": "pushed"], encoding: URLEncoding.default)
        case .branches(_, let protected):
            return .requestParameters(parameters: ["protected": "\(protected)"], encoding: URLEncoding.default)
        case .repositories(let repoName):
            return .requestParameters(parameters: ["q": repoName, "sort": "pushed"], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
        
    }
    
    public var baseURL: URL {
        switch self {
        case .userProfileImage(let urlString):
            return URL(string: urlString)!
        default:
            return URL(string: Constants.API.baseGitHubUrl)!
        }
        
    }
    
    public var sampleData: Data {
        return Data()
    }
}

extension GitHubApi {
    static let sharedProviderInstance: Reactive<RxMoyaProvider<GitHubApi>> = {
        RxMoyaProvider<GitHubApi>().rx
    }()
}
