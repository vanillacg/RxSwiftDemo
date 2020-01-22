//
//  RxObjectMapper.swift
//  CGMK
//
//  Created by chenguang on 2020/1/22.
//  Copyright © 2020 chenguang. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

public enum RxObjectMapperError: Error {
    case parsingError
}

public extension Observable where Element:Any {
    func mapObject<T>(type:T.Type) -> Observable<T> where T:Mappable {
        let mapper = Mapper<T>()
        return self.map { (element) -> T in
            guard let parsedElement = mapper.map(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            return parsedElement
        }
    }

    func mapArray<T>(type:T.Type) -> Observable<[T]> where T:Mappable{
        let mapper = Mapper<T>()
        
        return self.map { (element) -> [T] in
            guard let parsedArray = mapper.mapArray(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            return parsedArray
        }
    }
}
