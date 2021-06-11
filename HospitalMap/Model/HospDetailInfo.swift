//
//  HospDetailInfo.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/11.
//

import Foundation

struct HospDetailInfo: SearchResultItemType {
    let plcNm: String?
    let plcDir: String?
    let plcDist: String?
    let parkXpnsYn: String?
    let parkEtc: String?
    let rcvWeek: String?
    let lunchWeek: String?
    let rcvSat: String?
    let lunchSat: String?
    let noTrmtHoli: String?
    let noTrmtSun: String?
    let emyDayYn: String?
    let emyNgtYn: String?
    let parkQty: Int?
}
