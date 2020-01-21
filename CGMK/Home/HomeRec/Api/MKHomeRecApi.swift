//
//  MKHomeRecApi.swift
//  CGMK
//
//  Created by chenguang on 2019/5/17.
//  Copyright © 2019 chenguang. All rights reserved.
//

import Foundation
import Moya

let MKHomeRecApiProvider = MoyaProvider<MKHomeApi>()

public enum MKHomeApi {
    case homeRecommendList
}

extension MKHomeApi: TargetType {
    //请求地址
    public var baseURL: URL {
        switch self {
        case .homeRecommendList:
            return URL(string: BASE_URL)!
        }
    }
    
    public var path: String {
        switch self {
        case .homeRecommendList:
            return "/article/category/get_subscribed/v1/?"
        }
    }
    
    public var method: Moya.Method {return .get}
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        let parameters = [
            "device_id": device_id,
             "iid": iid] as [String : Any]
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}



