//
//  MKHomeRecApi.swift
//  CGMK
//
//  Created by chenguang on 2019/5/17.
//  Copyright © 2019 chenguang. All rights reserved.
//

import Foundation
import Moya

let MKHomeRecApiProvider = MoyaProvider<MKHomeRecApi>()

public enum MKHomeRecApi {
    case recommendFeed
    case homeRecommendList
}

extension MKHomeRecApi: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    
    //请求地址
    public var baseURL: URL {
        switch self {
        case .recommendFeed:
            return URL(string: BASE_URL)!
        case .homeRecommendList:
            return URL(string: BASE_URL)!
        }
    }
    
    public var path: String {
        switch self {
            case .recommendFeed:
                return "/api/news/feed/v75/?"
            case .homeRecommendList:
                return "/article/category/get_subscribed/v1/?"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .recommendFeed:
            let pullTime = Date().timeIntervalSince1970
            var ttFrom:TTFrom?
            let params = [
            "device_id": device_id,
            "count": 20,
            "list_count": 15,
            "category": "",
            "min_behot_time": pullTime,
            "strict": 0,
            "detail": 1,
            "refresh_reason": 1,
            "tt_from": "pull",
            "iid": iid
            ] as [String: Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .homeRecommendList:
            let parameters = [
                "device_id": device_id,
                "iid": iid] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}



