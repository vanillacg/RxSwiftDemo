//
//  JobModel.swift
//  CGMK
//
//  Created by chenguang on 2020/1/22.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import ObjectMapper

struct Channel: Mappable {
    var name: String?
    var nameEn: String?
    var channelId: String?
    var seqId: Int?
    var abbrEn: String?

    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seqId_id"]
        abbrEn <- map["abbr_en"]
    }
}

struct Douban: Mappable {
    var channels: [Channel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        channels <- map["channels"]
    }
}

struct Song: Mappable {
    var title: String!
    var artist: String!
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        title <- map["title"]
        artist <- map["artist"]
    }
}

struct Playlist: Mappable {
    var r: Int!
    var isShowQuickStart: Int!
    var song: [Song]!
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        r <- map["r"]
        isShowQuickStart <- map["is_show_quick_start"]
        song <- map["song"]
    }
}

