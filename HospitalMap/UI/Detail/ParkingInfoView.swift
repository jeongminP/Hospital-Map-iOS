//
//  ParkingInfoView.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/07/02.
//

import UIKit

class ParkingInfoView: UIView {
    
    //MARK: - Private Properties
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let parkQtyLabel = UILabel()
    private let parkEtcLabel = UILabel()
    
    //MARK: - Internal Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setParkingInfo(parkQty: Int?, parkEtc: String?) {
        if let parkQty = parkQty {
            parkQtyLabel.text = "주차 가능 대수 : " + String(parkQty) + "대"
        } else {
            parkQtyLabel.isHidden = true
        }
        
        if let parkEtc = parkEtc, !parkEtc.isEmpty {
            parkEtcLabel.text = parkEtc
            parkEtcLabel.textColor = .darkGray
            parkEtcLabel.lineBreakMode = .byWordWrapping
            parkEtcLabel.numberOfLines = 0
        } else {
            parkEtcLabel.isHidden = true
        }
    }
    
    //MARK: - Private Methods
    private func setupLayout() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        snp.makeConstraints { make in
            make.width.equalTo(frame.width - 20)
        }
        
        titleLabel.text = " 주차정보 "
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .iconBlue
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(30)
        }
        
        verticalStackView.addArrangedSubview(parkQtyLabel)
        verticalStackView.addArrangedSubview(parkEtcLabel)
        
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
