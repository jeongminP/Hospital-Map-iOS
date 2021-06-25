//
//  HospitalTableViewCell.swift
//  HospitalMap
//
//  Created by parkbirdfly on 2021/06/24.
//

import UIKit

class HospitalTableViewCell: UITableViewCell {

    
    @IBOutlet private var roundView: UIView?
    @IBOutlet private var verticalStackView: UIStackView?
    @IBOutlet private var telNoStackView: UIStackView?
    @IBOutlet private var hospNameLabel: UILabel?
    @IBOutlet private var addressLabel: UILabel?
    @IBOutlet private var callImageView: UIImageView?
    @IBOutlet private var telNoLabel: UILabel?
    @IBOutlet private var hospUrlLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout() {
        roundView?.layer.cornerRadius = 5
        
        hospNameLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        hospNameLabel?.textColor = UIColor.black
        hospNameLabel?.lineBreakMode = .byWordWrapping
        hospNameLabel?.numberOfLines = 0
        
        if let image = UIImage.init(named: "SF_phone_down_fill") {
            let imageSize: CGSize = CGSize(width: 15, height: 15)
            let resizedImage = image.resizedImage(for: imageSize)
                .withRenderingMode(.alwaysTemplate)
            callImageView?.image = resizedImage
        }
        callImageView?.tintColor = UIColor.darkGray
        
        addressLabel?.textColor = UIColor.black
        addressLabel?.lineBreakMode = .byWordWrapping
        addressLabel?.numberOfLines = 0
        
        telNoLabel?.textColor = UIColor.red
        
        hospUrlLabel?.lineBreakMode = .byWordWrapping
        hospUrlLabel?.numberOfLines = 0
    }
    
    func setHospitalInfo(item: HospitalInfo) {
        guard let telNoStackView = telNoStackView,
              let hospUrlLabel = hospUrlLabel else {
            return
        }
        
        if let name = item.hospName {
            hospNameLabel?.text = name
        }
        
        if let addr = item.addr {
            addressLabel?.text = addr
        }
        
        if let tel = item.telNo {
            telNoLabel?.text = tel
            telNoStackView.isHidden = false
            verticalStackView?.addArrangedSubview(telNoStackView)
        } else {
            telNoStackView.isHidden = true
            verticalStackView?.removeArrangedSubview(telNoStackView)
        }
        
        if let url = item.hospUrl {
            let textRange = NSMakeRange(0, url.count)
            let attributedString = NSMutableAttributedString.init(string: url)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: textRange)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: textRange)
            
            hospUrlLabel.attributedText = attributedString
            hospUrlLabel.isHidden = false
            verticalStackView?.addArrangedSubview(hospUrlLabel)
        } else {
            hospUrlLabel.isHidden = true
            verticalStackView?.removeArrangedSubview(hospUrlLabel)
        }
    }
}
