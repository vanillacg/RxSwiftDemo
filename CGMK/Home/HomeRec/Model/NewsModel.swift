//
//  NewsModel.swift
//  CGMK
//
//  Created by chenguang on 2019/5/22.
//  Copyright © 2019 chenguang. All rights reserved.
//

import Foundation
import HandyJSON

struct NewsContentJsonItem: HandyJSON {
    var content: String = ""
    var code: String = ""
    
}

struct NewsTipsModel: HandyJSON {
    var type: String = ""
    var display_duration: Int = 0
    var display_info: String = ""
    var display_template: String = ""
    var open_url: String = ""
    var web_url: String = ""
    var download_url: String = ""
    var app_name = ""
    var package_name: String = ""
}

struct NewsModel: HandyJSON {
    var message: String = ""
    var total_number: Int = 0
    var has_more: Bool = false
    var login_status: Int = 0
    var show_et_status: Int = 0
    var action_to_last_stick: Int = 0
    var feed_flag: Int = 0
    var post_content_hint: String = ""
    var is_use_bytedance_stream: Bool = false
    var tips = NewsTipsModel()
    var data = [NewsContentJsonItem]()
}

struct NewsActionList: HandyJSON {
    var action: Int = 0
    var desc: String = ""
    var extra: Dictionary<String, String> = [:]
    
}

struct NewsRecommendSponsor: HandyJSON {
    var icon_url: String = ""
    var label: String = ""
    var night_icon_url: String = ""
    var target_url: String = ""
}
struct NewsControlPannel: HandyJSON {
    var recommend_sponsor = NewsRecommendSponsor()
}
struct NewsFilterWords: HandyJSON {
    var id: String = ""
    var is_selected: Bool = false
    var name: String = ""
}
struct NewsForwardInfo: HandyJSON {
    var forward_count: Int = 0
}
struct NewsLabelExtra: HandyJSON {
    var icon_url:Dictionary<String,String> = [:]
    var is_redirect: Bool = false
    var redirect_url: String = ""
    var style_type: Int = 0
}
struct NewsUserInfo: HandyJSON {
    var avatar_url: String = ""
    var description: String = ""
    var follow: Bool = false
    var follower_count: Int = 0
    var live_info_type: Int = 0
    var name: String = ""
    var schema: String = ""
    var user_auth_info: String = ""
    var user_id: Int = 0
    var user_verified: Bool = false
    var verified_content: String = ""
}

struct NewsDetailVideoUrl: HandyJSON {
    var url: String = ""
}

struct NewsDetailVideoLargeImage: HandyJSON {
    var uri: String = ""
    var height: Int = 0
    var url: String = ""
    var url_list = [NewsDetailVideoUrl]()
    var width: Int = 0
}
struct NewsVideoDetailInfo: HandyJSON {
    var detail_video_large_image = NewsDetailVideoLargeImage()
    var direct_play: Int = 0
    var group_flags: Int = 0
    var show_pgc_subscribe: Int = 0
    var video_id: String = ""
    var video_preloading_flag: Int = 0
    var video_type: Int = 0
    var video_watch_count: Int = 0
    var video_watching_count: Int = 0
}

struct NewsMiddleImage: HandyJSON {
    var height: Int = 0
    var uri: String = ""
    var url: String = ""
    var url_list = [Dictionary<String,String>]()
}
struct NewsContentItem: HandyJSON {
    var abstract: String = ""
    var action_list = [NewsActionList]()
    var aggr_type: Int = 0
    var allow_download: Bool = false
    var article_sub_type: Int = 0
    var article_type: Int = 0
    var article_url: String = ""
    var article_version: Int = 0
    var ban_comment: Int = 0
    var behot_time: Int = 0
    var bury_count: Int = 0
    var cell_flag: Int = 0
    var cell_layout_style: Int = 0
    var cell_type: Int = 0
    var comment_count: Int = 0
    var content_decoration: String = ""
    var control_panel = NewsControlPannel()
    var cursor: Int = 0
    var digg_count: Int = 0
    var feed_title: Int = 0
    var filter_words = [NewsFilterWords]()
    var forward_info = NewsForwardInfo()
    var group_flags: Int = 0
    var group_id: Int = 0
    var group_source: Int = 0
    var has_m3u8_video: Bool = false
    var has_mp4_video: Int = 0
    var has_video: Bool = false
    var hot: Int = 0
    var ignore_web_transform: Int = 0
    var interaction_data: String = ""
    var is_stick: Bool = false
    var is_subject: Bool = false
    var item_id: Int = 0
    var item_version: Int = 0
    var keywords: String = ""
    var label: String = ""
    var label_extra = NewsLabelExtra()
    var label_style: Int = 0
    var level: Int = 0
    var media_name: String = ""
    var need_client_impr_recycle: Int = 0
    var play_auth_token: String = ""
    var play_biz_token: String = ""
    var publish_time: Int = 0
    var read_count: Int = 0
    var rid: String = ""
    var share_count: Int = 0
    var share_type: Int = 0
    var share_url: String = ""
    var show_dislike: Bool = false
    var source: Int = 0
    var source_icon_style: Int = 0
    var source_open_url: Int = 0
    var stick_label: Int = 0
    var stick_style: Int = 0
    var tag: String = ""
    var tag_id: Int = 0
    var title: String = ""
    var url: String = ""
    var user_info = NewsUserInfo()
    var user_repin: Int = 0
    var user_verified: Int = 0
    var verified_content: String = ""
    var video_detail_info = NewsVideoDetailInfo()
    var video_duration: Int = 0
    var video_style: Int = 0
    var video_id: String = ""
    var middle_image = NewsMiddleImage()
}


