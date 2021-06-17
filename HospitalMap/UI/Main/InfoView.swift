//
//  InfoView.swift
//  HospitalMap
//
//  Created by parkbirdfly on 2021/06/16.
//

import Foundation

class InfoView: UIView {
    private let verticalStackView = UIStackView()
    private let hospNameLabel = UILabel()
    private let codeNameLabel = UILabel()
    private let addressLabel = UILabel()
    private let telNoLabel = UILabel()
    private let hospUrlLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 7
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1
        
        hospNameLabel.text = "병원 이름"
        hospNameLabel.textColor = UIColor.black
        hospNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        codeNameLabel.text = "코드명"
        codeNameLabel.textColor = UIColor.darkGray
        codeNameLabel.font = UIFont.systemFont(ofSize: 15)
        
        addressLabel.text = "주소"
        addressLabel.textColor = UIColor.black
        telNoLabel.text = "000-0000-0000"
        telNoLabel.textColor = UIColor.red
        hospUrlLabel.text = "홈페이지 주소"
        hospUrlLabel.textColor = UIColor.blue
        
        addSubview(hospNameLabel)
        addSubview(codeNameLabel)
        addSubview(addressLabel)
        addSubview(telNoLabel)
        addSubview(hospUrlLabel)
        
        hospNameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
        }
        codeNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(hospNameLabel.snp.bottom)
        }
        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(codeNameLabel.snp.bottom).offset(10)
        }
        telNoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(addressLabel.snp.bottom)
        }
        hospUrlLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(telNoLabel.snp.bottom)
        }
        
        //TODO: - 뷰의 높이를 어떻게 유동적이게 할지 고민해보기
    }
}
