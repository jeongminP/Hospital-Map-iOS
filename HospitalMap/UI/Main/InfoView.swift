//
//  InfoView.swift
//  HospitalMap
//
//  Created by parkbirdfly on 2021/06/16.
//

import Foundation

protocol InfoViewDelegate: AnyObject {
    func infoView(_ infoView: InfoView, didTappedTelNoView telNoView: UIView, of hospitalInfo: HospitalInfo)
    func infoView(_ infoView: InfoView, didTappedHospUrlView hospUrlView: UIView, of hospitalInfo: HospitalInfo)
}

class InfoView: UIView {
    
    //MARK: - Private Properties
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
    private(set) var hospitalInfo: HospitalInfo?
    
    //MARK: - Internal Property
    weak var delegate: InfoViewDelegate?
    
    //MARK: - Internal Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHospitalInfo(item: HospitalInfo, distance: Double?) {
        hospitalInfo = item
        
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
        } else {
            telNoStackView.isHidden = true
        }
        
        if let url = item.hospUrl {
            let textRange = NSMakeRange(0, url.count)
            let attributedString = NSMutableAttributedString.init(string: url)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: textRange)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: textRange)
            hospUrlLabel.attributedText = attributedString
            hospUrlLabel.isHidden = false
        } else {
            hospUrlLabel.isHidden = true
        }
        
        if let distance = distance {
            distanceLabel.text = String(format: "%.2f km", distance)
            distanceLabel.isHidden = false
        } else {
            distanceLabel.isHidden = true
        }
    }
    
    func setCodeNameLabel(clCdNm: String, dgsbjtStr: String) {
        codeNameLabel.text = clCdNm + " | " + dgsbjtStr
    }
    
    //MARK: - Private Methods
    private func setupLayout() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 7
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1
        
        setupHospNameStackView()
        setupCodeNameAndAddrLabel()
        setupTelNoStackView()
        setupHospUrlLabel()
        setupVerticalStackView()
    }
    
    private func setupHospNameStackView() {
        hospNameLabel.textColor = UIColor.black
        hospNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        hospNameStackView.addArrangedSubview(hospNameLabel)
        
        distanceLabel.textColor = UIColor.darkGray
        distanceLabel.font = UIFont.systemFont(ofSize: 15)
        distanceLabel.isHidden = true
        hospNameStackView.addArrangedSubview(distanceLabel)
        
        hospNameStackView.axis = .horizontal
        hospNameStackView.alignment = .bottom
        hospNameStackView.spacing = 10
        verticalStackView.addArrangedSubview(hospNameStackView)
    }
    
    private func setupCodeNameAndAddrLabel() {
        codeNameLabel.textColor = UIColor.darkGray
        codeNameLabel.font = UIFont.systemFont(ofSize: 15)
        codeNameLabel.lineBreakMode = .byWordWrapping
        codeNameLabel.numberOfLines = 0
        verticalStackView.addArrangedSubview(codeNameLabel)
        
        let spaceView = UILabel()
        spaceView.font = UIFont.systemFont(ofSize: 10)
        spaceView.text = " "
        verticalStackView.addArrangedSubview(spaceView)
        
        addressLabel.textColor = UIColor.black
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 0
        verticalStackView.addArrangedSubview(addressLabel)
    }
    
    private func setupTelNoStackView() {
        if let image = UIImage.init(named: "SF_phone_down_fill") {
            let imageSize: CGSize = CGSize(width: 15, height: 15)
            let resizedImage = image.resizedImage(for: imageSize)
                .withRenderingMode(.alwaysTemplate)
            callImageView.image = resizedImage
        }
        callImageView.tintColor = UIColor.darkGray
        telNoStackView.addArrangedSubview(callImageView)
        
        telNoLabel.textColor = UIColor.red
        telNoStackView.addArrangedSubview(telNoLabel)
        
        telNoStackView.axis = .horizontal
        telNoStackView.alignment = .center
        telNoStackView.spacing = 5
        telNoStackView.isUserInteractionEnabled = true
        let telNoTap = UITapGestureRecognizer(target: self, action: #selector(telNoStackViewDidTapped))
        telNoStackView.addGestureRecognizer(telNoTap)
        verticalStackView.addArrangedSubview(telNoStackView)
    }
    
    private func setupHospUrlLabel() {
        hospUrlLabel.lineBreakMode = .byWordWrapping
        hospUrlLabel.numberOfLines = 0
        hospUrlLabel.isUserInteractionEnabled = true
        let hospUrlTap = UITapGestureRecognizer(target: self, action: #selector(hospUrlLabelDidTapped))
        hospUrlLabel.addGestureRecognizer(hospUrlTap)
        verticalStackView.addArrangedSubview(hospUrlLabel)
    }
    
    private func setupVerticalStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 3
        addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    //MARK: - Private Methods - Actions
    
    @objc private func telNoStackViewDidTapped() {
        guard let hospitalInfo = hospitalInfo else {
            return
        }
        delegate?.infoView(self, didTappedTelNoView: telNoLabel, of: hospitalInfo)
    }
    
    @objc private func hospUrlLabelDidTapped() {
        guard let hospitalInfo = hospitalInfo else {
            return
        }
        delegate?.infoView(self, didTappedHospUrlView: hospUrlLabel, of: hospitalInfo)
    }
}
