//
//  JobAPI.swift
//  CGMK
//
//  Created by chenguang on 2020/1/22.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import Moya

public enum DouBanApi {
    case channels //获取频道
    case playlist(String) //获取歌曲
}

extension DouBanApi: TargetType {
    
    public var baseURL: URL{
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
        case .playlist(_):
            return URL(string: "https://douban.fm")!
        }
    }
    
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
        case .playlist(_):
            return "/j/mine/playlist"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .channels:
            return .requestPlain
        case .playlist(let channel):
            var params: [String: Any] = [:]
            params["channel"] = channel
            params["type"] = "n"
            params["from"] = "mainsite"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}

let DouBanProvider = MoyaProvider<DouBanApi>()
