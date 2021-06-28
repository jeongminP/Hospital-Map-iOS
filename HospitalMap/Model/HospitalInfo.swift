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
    let xPos: DynamicJsonProperty?
    let yPos: DynamicJsonProperty?
    
    func getXPos() -> Double? {
        switch xPos {
        case .string(let val):
            return Double(val)
        case .double(let val):
            return val
        case .none:
            return nil
        }
    }
    
    func getYPos() -> Double? {
        switch yPos {
        case .string(let val):
            return Double(val)
        case .double(let val):
            return val
        case .none:
            return nil
        }
    }
    
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
    
    enum DynamicJsonProperty: Codable, Equatable {
        case string(String)
        case double(Double)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            do {
                let stringValue = try container.decode(String.self)
                self = .string(stringValue)
            } catch DecodingError.typeMismatch{
                let doubleValue = try container.decode(Double.self)
                self = .double(doubleValue)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let val):
                try container.encode(val)
            case .double(let val):
                try container.encode(val)
            }
        }
    }
}
