//
//  HospitalInfo.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/11.
//

import Foundation

struct HospitalInfo: SearchResultItemType {
    let ykiho: String?
    let hospName: String?
    let classCodeName: String?
    let addr: String?
    let telNo: String?
    let hospUrl: String?
    let estbDate: Int?
    let doctorTotalCnt: Int?
    let specialistDoctorCnt: Int?
    let generalDoctorCnt: Int?
    let residentCnt: Int?
    let internCnt: Int?
    let xPos: Double?
    let yPos: Double?
    
    enum CodingKeys: String, CodingKey {
        case ykiho
        case hospName = "yadmNm"
        case classCodeName = "clCdNm"
        case addr
        case telNo = "telno"
        case hospUrl
        case estbDate = "estbDd"
        case doctorTotalCnt = "drTotCnt"
        case specialistDoctorCnt = "sdrCnt"
        case generalDoctorCnt = "gdrCnt"
        case residentCnt = "resdntCnt"
        case internCnt = "intnCnt"
        case xPos = "XPos"
        case yPos = "YPos"
    }
}
