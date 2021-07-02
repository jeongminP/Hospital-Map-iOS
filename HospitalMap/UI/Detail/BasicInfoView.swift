//
//  BasicInfoView.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/29.
//

import UIKit
import SnapKit

protocol BasicInfoViewDelegate: AnyObject {
    func basicInfoView(_ basicInfoView: BasicInfoView, didTappedTelNoView telNoView: UIView)
    func basicInfoView(_ basicInfoView: BasicInfoView, didTappedHospUrlView hospUrlView: UIView)
}

class BasicInfoView: UIView {
    
    //MARK: - Private Properties
    private let verticalStackView = UIStackView()
    private let addressStackView = UIStackView()
    private let basicInfoLabel = UILabel()
    private let codeNameLabel = UILabel()
    private let placeLabel = UILabel()
    private let telNoLabel = UILabel()
    private let hospUrlLabel = UILabel()
    private let estbDdLabel = UILabel()
    private let hospitalInfo: HospitalInfo
    
    //MARK: - Internal Property
    weak var delegate: BasicInfoViewDelegate?
    
    //MARK: - Internal Methods
    init(frame: CGRect, hospitalInfoItem: HospitalInfo) {
        self.hospitalInfo = hospitalInfoItem
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCodeNameLabel(clCdNm: String?, dgsbjtStr: String) {
        if let clCdNm = clCdNm {
            codeNameLabel.text = clCdNm + " | " + dgsbjtStr
        } else {
            codeNameLabel.text = dgsbjtStr
        }
    }
    
    func setPlaceLabel(place: String) {
        if place.isEmpty {
            placeLabel.isHidden = true
            return
        }
        placeLabel.text = place
        placeLabel.font = UIFont.systemFont(ofSize: 15)
        placeLabel.textColor = .darkGray
        placeLabel.isHidden = false
    }
    
    //MARK: - Private Methods
    private func setupLayout() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        snp.makeConstraints { make in
            make.width.equalTo(frame.width - 20)
        }
        
        basicInfoLabel.text = " 기본정보 "
        basicInfoLabel.textColor = .white
        basicInfoLabel.backgroundColor = .iconBlue
        addSubview(basicInfoLabel)
        basicInfoLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(30)
        }
        
        setupHospNameAndCodeNameLabel()
        setupAddressStackView()
        setupTelNoStackView()
        setupHospUrlStackView()
        setupEstbDateLabel()
        setupDoctorStackView()
        setupVerticalStackView()
    }
    
    private func setupHospNameAndCodeNameLabel() {
        if let name = hospitalInfo.hospName {
            let hospNameLabel = UILabel()
            hospNameLabel.text = name
            hospNameLabel.textColor = UIColor.black
            hospNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            verticalStackView.addArrangedSubview(hospNameLabel)
        }
        
        if let code = hospitalInfo.classCodeName {
            codeNameLabel.text = code
        }
        codeNameLabel.textColor = UIColor.darkGray
        codeNameLabel.font = UIFont.systemFont(ofSize: 15)
        codeNameLabel.lineBreakMode = .byWordWrapping
        codeNameLabel.numberOfLines = 0
        verticalStackView.addArrangedSubview(codeNameLabel)
    }
    
    private func setupAddressStackView() {
        addressStackView.addArrangedSubview(makeSpaceView(ofSize: 10))
        
        let addrTitleLabel = UILabel()
        addrTitleLabel.text = "주소"
        addrTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addressStackView.addArrangedSubview(addrTitleLabel)
        
        if let addr = hospitalInfo.addr {
            let addressLabel = UILabel()
            addressLabel.text = addr
            addressLabel.textColor = UIColor.black
            addressLabel.font = UIFont.systemFont(ofSize: 15)
            addressLabel.lineBreakMode = .byWordWrapping
            addressLabel.numberOfLines = 0
            addressStackView.addArrangedSubview(addressLabel)
        }
        
        placeLabel.lineBreakMode = .byWordWrapping
        placeLabel.numberOfLines = 0
        addressStackView.addArrangedSubview(placeLabel)
        
        addressStackView.axis = .vertical
        addressStackView.alignment = .leading
        addressStackView.spacing = 3
        verticalStackView.addArrangedSubview(addressStackView)
    }
    
    private func setupTelNoStackView() {
        let telNoVerticalStackView = UIStackView()
        telNoVerticalStackView.axis = .vertical
        telNoVerticalStackView.alignment = .leading
        telNoVerticalStackView.spacing = 3
        
        let telNoHorizontalStackView = UIStackView()
        telNoHorizontalStackView.axis = .horizontal
        telNoHorizontalStackView.alignment = .center
        telNoHorizontalStackView.spacing = 5
        
        telNoVerticalStackView.addArrangedSubview(makeSpaceView(ofSize: 10))
        
        let telNoTitleLabel = UILabel()
        telNoTitleLabel.text = "전화번호"
        telNoTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        telNoVerticalStackView.addArrangedSubview(telNoTitleLabel)
        
        if let image = UIImage.init(named: "SF_phone_down_fill") {
            let callImageView = UIImageView()
            let imageSize: CGSize = CGSize(width: 15, height: 15)
            let resizedImage = image.resizedImage(for: imageSize)
                .withRenderingMode(.alwaysTemplate)
            callImageView.image = resizedImage
            callImageView.tintColor = UIColor.darkGray
            callImageView.isUserInteractionEnabled = false
            telNoHorizontalStackView.addArrangedSubview(callImageView)
        }
        
        if let tel = hospitalInfo.telNo,
           !tel.isEmpty {
            telNoLabel.text = tel
            telNoLabel.textColor = UIColor.red
            telNoHorizontalStackView.addArrangedSubview(telNoLabel)
            telNoVerticalStackView.addArrangedSubview(telNoHorizontalStackView)
            verticalStackView.addArrangedSubview(telNoVerticalStackView)
        } else {
            telNoVerticalStackView.isHidden = true
        }
        
        let telNoTap = UITapGestureRecognizer(target: self, action: #selector(telNoStackViewDidTapped))
        telNoVerticalStackView.addGestureRecognizer(telNoTap)
        telNoVerticalStackView.isUserInteractionEnabled = true
    }
    
    private func setupHospUrlStackView() {
        let hospUrlStackView = UIStackView()
        hospUrlStackView.axis = .vertical
        hospUrlStackView.alignment = .leading
        hospUrlStackView.spacing = 3
        
        hospUrlStackView.addArrangedSubview(makeSpaceView(ofSize: 10))
        
        let urlTitleLabel = UILabel()
        urlTitleLabel.text = "홈페이지"
        urlTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        hospUrlStackView.addArrangedSubview(urlTitleLabel)
        
        if let url = hospitalInfo.hospUrl,
           !url.isEmpty {
            let textRange = NSMakeRange(0, url.count)
            let attributedString = NSMutableAttributedString.init(string: url)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: textRange)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: textRange)
            hospUrlLabel.attributedText = attributedString
            
            hospUrlLabel.lineBreakMode = .byWordWrapping
            hospUrlLabel.numberOfLines = 0
            
            hospUrlStackView.addArrangedSubview(hospUrlLabel)
            verticalStackView.addArrangedSubview(hospUrlStackView)
        } else {
            hospUrlStackView.isHidden = true
        }
        
        let hospUrlTap = UITapGestureRecognizer(target: self, action: #selector(hospUrlStackViewDidTapped))
        hospUrlStackView.addGestureRecognizer(hospUrlTap)
        hospUrlStackView.isUserInteractionEnabled = true
    }
    
    private func setupEstbDateLabel() {
        guard let estbDd = hospitalInfo.estbDate else {
            return
        }
        
        verticalStackView.addArrangedSubview(makeSpaceView(ofSize: 10))
        
        var estbStr = String(estbDd)
        estbStr.insert("-", at: estbStr.index(estbStr.startIndex, offsetBy: 4))
        estbStr.insert("-", at: estbStr.index(estbStr.endIndex, offsetBy: -2))
        
        let estbDateLabel = UILabel()
        estbDateLabel.text = "개설일자 : " + estbStr
        verticalStackView.addArrangedSubview(estbDateLabel)
    }
    
    private func setupDoctorStackView() {
        let doctorStackView = UIStackView()
        doctorStackView.axis = .vertical
        doctorStackView.alignment = .leading
        doctorStackView.spacing = 3
        
        doctorStackView.addArrangedSubview(makeSpaceView(ofSize: 10))
        
        guard let drTotCnt = hospitalInfo.doctorTotalCnt else {
            doctorStackView.isHidden = true
            return
        }
        
        let totalLabel = UILabel()
        totalLabel.text = "의사 총 수 : \(drTotCnt)명"
        doctorStackView.addArrangedSubview(totalLabel)
        
        if let sdrCnt = hospitalInfo.specialistDoctorCnt,
           sdrCnt != 0 {
            let sdrLabel = UILabel()
            sdrLabel.text = " - 전문의 : \(sdrCnt)명"
            doctorStackView.addArrangedSubview(sdrLabel)
        }
        if let gdrCnt = hospitalInfo.generalDoctorCnt,
           gdrCnt != 0 {
            let gdrLabel = UILabel()
            gdrLabel.text = " - 일반의 : \(gdrCnt)명"
            doctorStackView.addArrangedSubview(gdrLabel)
        }
        if let resdntCnt = hospitalInfo.residentCnt,
           resdntCnt != 0 {
            let resdntLabel = UILabel()
            resdntLabel.text = " - 레지던트 : \(resdntCnt)명"
            doctorStackView.addArrangedSubview(resdntLabel)
        }
        if let intnCnt = hospitalInfo.internCnt,
           intnCnt != 0 {
            let intnLabel = UILabel()
            intnLabel.text = " - 인턴 : \(intnCnt)명"
            doctorStackView.addArrangedSubview(intnLabel)
        }
        
        verticalStackView.addArrangedSubview(doctorStackView)
    }
    
    private func setupVerticalStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 3
        addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(basicInfoLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func makeSpaceView(ofSize: CGFloat) -> UIView {
        let spaceView = UILabel()
        spaceView.font = UIFont.systemFont(ofSize: ofSize)
        spaceView.text = " "
        return spaceView
    }
    
    //MARK: - Private Methods - Actions
    @objc private func telNoStackViewDidTapped() {
        delegate?.basicInfoView(self, didTappedTelNoView: telNoLabel)
    }
    
    @objc private func hospUrlStackViewDidTapped() {
        delegate?.basicInfoView(self, didTappedHospUrlView: hospUrlLabel)
    }
}
