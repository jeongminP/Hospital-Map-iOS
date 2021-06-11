//
//  DepartmentCode.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/11.
//

import Foundation

enum DepartmendCode: String, CaseIterable {
    case IM = "01"
    case NR = "02"
    case NP = "03"
    case GS = "04"
    case OS = "05"
    case NS = "06"
    case CS = "07"
    case PS = "08"
    case ANE = "09"
    case OBGY = "10"
    case PED = "11"
    case EY = "12"
    case ENT = "13"
    case DER = "14"
    case UR = "15"
    case RAD = "16"
    case RO = "17"
    case LM = "19"
    case RM = "21"
    case FM = "23"
    case DEN = "49"
    case OMC = "80"
    
    var departmentName: String {
        switch self {
        case .IM: return "내과"
        case .NR: return "신경과"
        case .NP: return "정신건강의학과"
        case .GS: return "외과"
        case .OS: return "정형외과"
        case .NS: return "신경외과"
        case .CS: return "흉부외과"
        case .PS: return "성형외과"
        case .ANE: return "마취통증의학과"
        case .OBGY: return "산부인과"
        case .PED: return "소아청소년과"
        case .EY: return "안과"
        case .ENT: return "이비인후과"
        case .DER: return "피부과"
        case .UR: return "비뇨기과"
        case .RAD: return "영상의학과"
        case .RO: return "방사선종양학과"
        case .LM: return "진단검사의학과"
        case .RM: return "재활의학과"
        case .FM: return "가정의학과"
        case .DEN: return "치과"
        case .OMC: return "한의원"
        }
    }
}
