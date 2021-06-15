//
//  ChoiceDeptView.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/15.
//

import Foundation

class ChoiceDeptView: UIButton {
    private let verticalStackView = UIStackView()
    private let choiceTitleLabel = UILabel()
    private let selectedDeptLabel = UILabel()
    private let rightImageView = UIImageView()
    
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
        
        choiceTitleLabel.text = "진료과"
        choiceTitleLabel.textColor = UIColor.darkGray
        choiceTitleLabel.font = UIFont.systemFont(ofSize: 15)
        verticalStackView.addArrangedSubview(choiceTitleLabel)
        
        selectedDeptLabel.text = "내과"
        selectedDeptLabel.font = UIFont.systemFont(ofSize: 20)
        verticalStackView.addArrangedSubview(selectedDeptLabel)
        
        if let image = UIImage.init(named: "SF_chevron_right_square_fill") {
            let imageSize: CGSize = CGSize(width: 20, height: 20)
            let resizedImage = image.resizedImage(for: imageSize)
                .withRenderingMode(.alwaysTemplate)
            rightImageView.image = resizedImage
        }
        rightImageView.tintColor = UIColor.darkGray
        rightImageView.isUserInteractionEnabled = false
        addSubview(rightImageView)
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(20)
        }
        
        setupStackView()
    }
    
    private func setupStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 3
        verticalStackView.alignment = .leading
        verticalStackView.isUserInteractionEnabled = false
        addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(rightImageView.snp.leading)
        }
    }
}
