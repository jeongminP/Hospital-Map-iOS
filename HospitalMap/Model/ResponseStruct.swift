//
//  ResponseStruct.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/11.
//

import Foundation

typealias SearchResultItemType = Codable & Equatable

struct ResponseStruct<T: SearchResultItemType>: Codable {
    let response: DetailInfoResponse<T>?
}

struct DetailInfoResponse<T: SearchResultItemType>: Codable {
    let header: DetailInfoHeader?
    let body: DetailInfoBody<T>?
}

struct DetailInfoHeader: Codable {
    let resultCode: String?
    let resultMsg: String?
}

struct DetailInfoBody<T: SearchResultItemType>: Codable {
    let totalCount: Int?
    let pageNo: Int?
    let numOfRows: Int?
    let items: [String: T?]?
    
    var hasNext: Bool {
        guard let pageNo = pageNo,
            let numOfRows = numOfRows,
            let totalCount = totalCount else {
                return false
        }
        return pageNo + numOfRows < totalCount
    }
}
