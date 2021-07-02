//
//  EmergencyInfoView.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/07/02.
//

import UIKit

class EmergencyInfoView: UIView {
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let emyDayLabel = UILabel()
    private let emyNgtLabel = UILabel()
    
    //MARK: - internal methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEmergencyInfo(emyDayYn: String?, emyNgtYn: String?) {
        if let emyDayYn = emyDayYn, !emyDayYn.isEmpty {
            emyDayLabel.text = "주간 응급실 운영 : " + emyDayYn
            emyDayLabel.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            emyDayLabel.isHidden = true
        }
        
        if let emyNgtYn = emyNgtYn, !emyNgtYn.isEmpty {
            emyNgtLabel.text = "야간 응급실 운영 : " + emyNgtYn
            emyNgtLabel.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            emyNgtLabel.isHidden = true
        }
    }
    
    //MARK: - private methods
    private func setupLayout() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        snp.makeConstraints { make in
            make.width.equalTo(frame.width - 20)
        }
        
        titleLabel.text = " 응급실정보 "
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .iconBlue
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(30)
        }
        
        verticalStackView.addArrangedSubview(emyDayLabel)
        verticalStackView.addArrangedSubview(emyNgtLabel)
        
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
