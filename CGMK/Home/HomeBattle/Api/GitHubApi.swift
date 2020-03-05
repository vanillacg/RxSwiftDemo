//
//  GitHubApi.swift
//  CGMK
//
//  Created by chenguang on 2020/2/20.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import Moya

let GitHubProivder = MoyaProvider<GitHubAPI>()

public enum GitHubAPI {
    case repositories(String)
}

extension GitHubAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    public var task: Task {
        switch self {
        case .repositories(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}




