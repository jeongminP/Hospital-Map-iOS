//
//  LoadingView.swift
//  HospitalMap
//
//  Created by parkbirdfly on 2021/06/22.
//

import Foundation
import SnapKit

final class LoadingView: UIView {
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.7, alpha: 0.3)
        setupSpinner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        isHidden = false
        spinner.startAnimating()
    }
    
    func stopLoading() {
        isHidden = true
        spinner.stopAnimating()
    }
    
    // MARK: - private
    private func setupSpinner() {
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 100)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1)
        addSubview(spinner)
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
