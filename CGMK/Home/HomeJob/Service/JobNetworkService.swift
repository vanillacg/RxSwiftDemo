//
//  JobNetworkService.swift
//  CGMK
//
//  Created by chenguang on 2020/2/19.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper

class JobNetworkService {
    func loadChannels() -> Observable<[Channel]> {
        return DouBanProvider.rx.request(.channels).mapObject(Douban.self).map{ $0.channels ?? [] }.asObservable()
    }
    
    func loadChannelsDriver() -> Driver<[Channel]> {
           return DouBanProvider.rx.request(.channels).mapObject(Douban.self).map{ $0.channels ?? [] }.asDriver(onErrorJustReturn: [])
       }
    
    func loadPlaylist(channelId: String) -> Observable<Playlist> {
        return DouBanProvider.rx.request(.playlist(channelId)).mapObject(Playlist.self).asObservable()
    }
    
    func loadFirstSong(channelId: String) -> Observable<Song> {
        return loadPlaylist(channelId: channelId).filter{ $0.song.count > 0 }.map{ $0.song[0]}
    }
}
