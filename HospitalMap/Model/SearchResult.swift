//
//  SearchResult.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/11.
//

import Foundation

typealias SearchResultItemType = Codable & Equatable

struct ResponseStruct<T: SearchResultItemType>: Codable {
    let response: Response<T>?
    
    struct Response<T: SearchResultItemType>: Codable {
        let resultCode: String?
        let resultMsg: String?
        let body: SearchResult<T>?
    }
}

struct SearchResult<T: SearchResultItemType>: Codable {
    let totalCount: Int?
    let pageNo: Int?
    let numOfRows: Int?
    let items: [String: [T]]?
    
    var hasNext: Bool {
        guard let pageNo = pageNo,
            let numOfRows = numOfRows,
            let totalCount = totalCount else {
                return false
        }
        return pageNo + numOfRows < totalCount
    }
}
