//
//  GitHubModel.swift
//  CGMK
//
//  Created by chenguang on 2020/2/20.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import ObjectMapper

struct GitHubRepository: Mappable {
    var id: Int!
    var name: String!
    var fullName: String!
    var htmlUrl: String!
    var descripation: String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        htmlUrl <- map["html_url"]
        descripation <- map["description"]
    }
}

struct GitHubRepositories: Mappable {
    var totalCount: Int!
    var incompleteResults: Bool!
    var items: [GitHubRepository]!
    init() {
        totalCount = 0
        incompleteResults = false
        items = []
    }
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
}
