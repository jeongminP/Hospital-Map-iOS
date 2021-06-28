//
//  HospitalDBManager.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/23.
//

import Foundation
import SQLite3

final class HospitalDBManager {
    private let dbName = "hdb.db"
    
    private let sqlCreateHosp = "CREATE TABLE if not exists tb_hospbasislist ("
        + "_id integer primary key autoincrement,"
        + "addr text,"
        + "clCd text"
        + "clCdNm text,"
        + "drTotCnt integer,"
        + "estbDd integer,"
        + "gdrCnt integer,"
        + "hospUrl text,"
        + "intnCnt integer,"
        + "resdntCnt integer,"
        + "sdrCnt integer,"
        + "telno text,"
        + "XPos double,"
        + "YPos double,"
        + "yadmNm text,"
        + "ykiho text);"
    private let sqlCreateDgsbjt = "CREATE TABLE if not exists tb_dgsbjt ("
        + "_id integer primary key autoincrement,"
        + "ykiho text,"
        + "dgsbjtCd text,"
        + "dgsbjtCdNm text,"
        + "dgsbjtPrSdrCnt integer,"
        + "cdiagDrCnt integer);"
    private let sqlSearchHosp = "SELECT * "
        + "FROM tb_hospbasislist a INNER JOIN tb_dgsbjt b ON a.ykiho = b.ykiho "
    private let sqlDgsbjt = "SELECT * FROM tb_dgsbjt WHERE ykiho = "
    
    private var dbPath = ""
    private var db: OpaquePointer?
    
    // MARK: - internal
    init() {
        db = createTable()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    func createTable() -> OpaquePointer? {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docPath = dirPath[0]
        dbPath = docPath+"/"+dbName
        
        guard sqlite3_open(dbPath, &db) == SQLITE_OK,
            let db = db else {
                print("Unable to open database. Verify that you created the directory described " +
                    "in the Getting Started section.")
                return nil
        }
        
        var createHospTableStmt: OpaquePointer? = nil
        guard sqlite3_prepare_v2(db, sqlCreateHosp, -1, &createHospTableStmt, nil) == SQLITE_OK else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("CREATE TABLE Hosp statement could not be prepared. \(errorMessage)")
            return nil
        }
        
        defer {
            sqlite3_finalize(createHospTableStmt)
        }
        guard sqlite3_step(createHospTableStmt) == SQLITE_DONE else {
            print("Hosp table could not be created.")
            return nil
        }
        
        var createDgsbjtTableStmt: OpaquePointer? = nil
        guard sqlite3_prepare_v2(db, sqlCreateDgsbjt, -1, &createDgsbjtTableStmt, nil) == SQLITE_OK else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("CREATE TABLE Dgsbjt statement could not be prepared. \(errorMessage)")
            return nil
        }
        
        defer {
            sqlite3_finalize(createDgsbjtTableStmt)
        }
        guard sqlite3_step(createDgsbjtTableStmt) == SQLITE_DONE else {
            print("Dgsbjt table could not be created.")
            return nil
        }
        
        return db
    }
    
    func getHospitalList(clCd: String, emdongNm: String, completion: @escaping ([HospitalInfo], Bool) -> Void) {
        DispatchQueue.global().async { [weak self] in
            var queryStmt: OpaquePointer? = nil
            var hospitalItemList: [HospitalInfo] = []
            var success = false
            defer {
                completion(hospitalItemList, success)
            }
            
            guard let strongSelf = self else {
                return
            }
            
            let query = strongSelf.sqlSearchHosp
                + "WHERE b.dgsbjtCd = '\(clCd)' AND a.addr LIKE '%\(emdongNm)%'"
            
            guard sqlite3_prepare_v2(strongSelf.db, query, -1, &queryStmt, nil) == SQLITE_OK else {
                let errorMessage = String(cString: sqlite3_errmsg(self?.db))
                print("SELECT statement could not be prepared! \(errorMessage)")
                return
            }
            
            defer { // 완료 시 필수 실행
                sqlite3_finalize(queryStmt)
            }
            while sqlite3_step(queryStmt) == SQLITE_ROW {
                var ykiho, hospName, clCdNm, addr, telNo, hospUrl, dgsbjtCdNm: String?
                var estbDd, drTotCnt, sdrCnt, gdrCnt, resdntCnt, intnCnt: Int?
                var xPos, yPos: Double?
                
                if let addrCol = sqlite3_column_text(queryStmt, 1) {
                    addr = String(cString: addrCol)
                }
                if let clCdNmCol = sqlite3_column_text(queryStmt, 3) {
                    clCdNm = String(cString: clCdNmCol)
                }
                drTotCnt = Int(sqlite3_column_int(queryStmt, 4))
                estbDd = Int(sqlite3_column_int(queryStmt, 5))
                gdrCnt = Int(sqlite3_column_int(queryStmt, 6))
                if let hospUrlCol = sqlite3_column_text(queryStmt, 7) {
                    hospUrl = String(cString: hospUrlCol)
                }
                intnCnt = Int(sqlite3_column_int(queryStmt, 8))
                resdntCnt = Int(sqlite3_column_int(queryStmt, 9))
                sdrCnt = Int(sqlite3_column_int(queryStmt, 10))
                if let telNoCol = sqlite3_column_text(queryStmt, 11) {
                    telNo = String(cString: telNoCol)
                }
                xPos = Double(sqlite3_column_double(queryStmt, 12))
                yPos = Double(sqlite3_column_double(queryStmt, 13))
                if let hospNameCol = sqlite3_column_text(queryStmt, 14) {
                    hospName = String(cString: hospNameCol)
                }
                if let ykihoCol = sqlite3_column_text(queryStmt, 15) {
                    ykiho = String(cString: ykihoCol)
                }
                if let dgsbjtCdNmCol = sqlite3_column_text(queryStmt, 19) {
                    dgsbjtCdNm = String(cString: dgsbjtCdNmCol)
                }
                
                guard let xPos = xPos,
                      let yPos = yPos else {
                    continue
                }
                let hospItem = HospitalInfo(ykiho: ykiho,
                                            hospName: hospName,
                                            classCodeName: clCdNm,
                                            addr: addr,
                                            telNo: telNo,
                                            hospUrl: hospUrl,
                                            estbDate: estbDd,
                                            doctorTotalCnt: drTotCnt,
                                            specialistDoctorCnt: sdrCnt,
                                            generalDoctorCnt: gdrCnt,
                                            residentCnt: resdntCnt,
                                            internCnt: intnCnt,
                                            xPos: HospitalInfo.DynamicJsonProperty.double(xPos),
                                            yPos: HospitalInfo.DynamicJsonProperty.double(yPos))
                hospitalItemList.append(hospItem)
            }
            success = true
        }
    }
    
    func getDgsbjtList(ykiho: String, completion: @escaping ([String], Bool) -> Void) {
        DispatchQueue.global().async { [weak self] in
            var queryStmt: OpaquePointer? = nil
            var dgsbjtList: [String] = []
            var success = false
            defer {
                completion(dgsbjtList, success)
            }
            
            guard let strongSelf = self else {
                return
            }
            
            let query = strongSelf.sqlDgsbjt + "'\(ykiho)'"
            
            guard sqlite3_prepare_v2(strongSelf.db, query, -1, &queryStmt, nil) == SQLITE_OK else {
                let errorMessage = String(cString: sqlite3_errmsg(self?.db))
                print("SELECT statement could not be prepared! \(errorMessage)")
                return
            }
            
            defer { // 완료 시 필수 실행
                sqlite3_finalize(queryStmt)
            }
            
            while sqlite3_step(queryStmt) == SQLITE_ROW {
                if let dgsbjtCdNmCol = sqlite3_column_text(queryStmt, 3) {
                    dgsbjtList.append(String(cString: dgsbjtCdNmCol))
                }
            }
            success = true
        }
    }
}
