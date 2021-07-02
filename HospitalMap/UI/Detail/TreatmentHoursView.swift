//
//  TreatmentHoursView.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/07/02.
//

import UIKit

class TreatmentHoursView: UIView {
    
    //MARK: - Private Properties
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let rcvWeekLabel = UILabel()
    private let lunchWeekLabel = UILabel()
    private let rcvSatLabel = UILabel()
    private let lunchSatLabel = UILabel()
    private let noTrmtSunLabel = UILabel()
    private let noTrmtHoliLabel = UILabel()
    
    //MARK: - Internal Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTreatmentHours(rcvWeek: String?, lunchWeek: String?, rcvSat: String?, lunchSat: String?, sun: String?, holi: String?) {
        if let rcvWeek = rcvWeek, !rcvWeek.isEmpty {
            rcvWeekLabel.text = "평일 진료시간 : " + rcvWeek
        } else {
            rcvWeekLabel.isHidden = true
        }
        
        if let lunchWeek = lunchWeek, !lunchWeek.isEmpty {
            lunchWeekLabel.text = " - 평일 점심시간 : " + lunchWeek
        } else {
            lunchWeekLabel.isHidden = true
        }
        
        if let rcvSat = rcvSat, !rcvSat.isEmpty {
            rcvSatLabel.text = "토요일 진료시간 : " + rcvSat
        } else {
            rcvSatLabel.isHidden = true
        }
        
        if let lunchSat = lunchSat, !lunchSat.isEmpty {
            lunchSatLabel.text = " - 토요일 점심시간 : " + lunchSat
        } else {
            lunchSatLabel.isHidden = true
        }
        
        if let sun = sun, !sun.isEmpty {
            noTrmtSunLabel.text = "일요일 " + sun
        } else {
            noTrmtSunLabel.isHidden = true
        }
        
        if let holi = holi, !holi.isEmpty {
            noTrmtHoliLabel.text = "공휴일 " + holi
        } else {
            noTrmtHoliLabel.isHidden = true
        }
    }
    
    //MARK: - Private Methods
    private func setupLayout() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        snp.makeConstraints { make in
            make.width.equalTo(frame.width - 20)
        }
        
        titleLabel.text = " 진료시간 "
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .iconBlue
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(30)
        }
        
        verticalStackView.addArrangedSubview(rcvWeekLabel)
        verticalStackView.addArrangedSubview(lunchWeekLabel)
        verticalStackView.addArrangedSubview(rcvSatLabel)
        verticalStackView.addArrangedSubview(lunchSatLabel)
        verticalStackView.addArrangedSubview(noTrmtSunLabel)
        verticalStackView.addArrangedSubview(noTrmtHoliLabel)
        
        setupVerticalStackView()
    }
    
    private func setupVerticalStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 3
        addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
