//
//  InfoView.swift
//  HospitalMap
//
//  Created by parkbirdfly on 2021/06/16.
//

import Foundation

class InfoView: UIView {
    private let verticalStackView = UIStackView()
    private let hospNameStackView = UIStackView()
    private let telNoStackView = UIStackView()
    private let hospNameLabel = UILabel()
    private let distanceLabel = UILabel()
    private let codeNameLabel = UILabel()
    private let addressLabel = UILabel()
    private let callImageView = UIImageView()
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
        distanceLabel.text = "거리"
        distanceLabel.textColor = UIColor.darkGray
        distanceLabel.font = UIFont.systemFont(ofSize: 15)
        
        codeNameLabel.text = "코드명"
        codeNameLabel.textColor = UIColor.darkGray
        codeNameLabel.font = UIFont.systemFont(ofSize: 15)
        
        let spaceView = UILabel()
        spaceView.text = " "
        
        if let image = UIImage.init(named: "SF_phone_down_fill") {
            let imageSize: CGSize = CGSize(width: 15, height: 15)
            let resizedImage = image.resizedImage(for: imageSize)
                .withRenderingMode(.alwaysTemplate)
            callImageView.image = resizedImage
        }
        callImageView.tintColor = UIColor.darkGray
        callImageView.isUserInteractionEnabled = false
        
        addressLabel.text = "주소"
        addressLabel.textColor = UIColor.black
        telNoLabel.text = "000-0000-0000"
        telNoLabel.textColor = UIColor.red
        
        let hospUrlText = "홈페이지 주소"
        let textRange = NSMakeRange(0, hospUrlText.count)
        let attributedString = NSMutableAttributedString.init(string: hospUrlText)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: textRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: textRange)
        hospUrlLabel.attributedText = attributedString
        hospUrlLabel.isUserInteractionEnabled = true
        
        let hospUrlTap = UITapGestureRecognizer(target: self, action: #selector(hospUrlLabelDidTapped))
        hospUrlLabel.addGestureRecognizer(hospUrlTap)
        
        hospNameStackView.addArrangedSubview(hospNameLabel)
        hospNameStackView.addArrangedSubview(distanceLabel)
        
        telNoStackView.addArrangedSubview(callImageView)
        telNoStackView.addArrangedSubview(telNoLabel)
        telNoStackView.isUserInteractionEnabled = true
        let telNoTap = UITapGestureRecognizer(target: self, action: #selector(telNoStackViewDidTapped))
        telNoStackView.addGestureRecognizer(telNoTap)
        
        verticalStackView.addArrangedSubview(hospNameStackView)
        verticalStackView.addArrangedSubview(codeNameLabel)
        verticalStackView.addArrangedSubview(spaceView)
        verticalStackView.addArrangedSubview(addressLabel)
        
        setupStackView()
    }
    
    private func setupStackView() {
        hospNameStackView.axis = .horizontal
        hospNameStackView.alignment = .bottom
        hospNameStackView.spacing = 10
        
        telNoStackView.axis = .horizontal
        telNoStackView.alignment = .center
        telNoStackView.spacing = 5
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    @objc private func telNoStackViewDidTapped() {
        guard let telNo = telNoLabel.text,
              let url = URL(string: "tel://" + telNo) else {
            return
        }
        
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: { success in })
    }
    
    @objc private func hospUrlLabelDidTapped() {
        guard let hospUrl = hospUrlLabel.text,
              let url = URL(string: hospUrl) else {
            return
        }
        
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: { success in })
    }
    
    func setHospitalInfo(item: HospitalInfo) {
        if let name = item.hospName {
            hospNameLabel.text = name
        }
        if let code = item.classCodeName {
            codeNameLabel.text = code
        }
        
        if let addr = item.addr {
            addressLabel.text = addr
        }
        
        if let tel = item.telNo {
            telNoLabel.text = tel
            telNoStackView.isHidden = false
            verticalStackView.addArrangedSubview(telNoStackView)
        } else {
            telNoStackView.isHidden = true
            verticalStackView.removeArrangedSubview(telNoStackView)
        }
        
        if let url = item.hospUrl {
            let textRange = NSMakeRange(0, url.count)
            let attributedString = NSMutableAttributedString.init(string: url)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: textRange)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: textRange)
            
            hospUrlLabel.attributedText = attributedString
            hospUrlLabel.isHidden = false
            verticalStackView.addArrangedSubview(hospUrlLabel)
        } else {
            hospUrlLabel.isHidden = true
            verticalStackView.removeArrangedSubview(hospUrlLabel)
        }
    }
}
