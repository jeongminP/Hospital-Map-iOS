//
//  Extension.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/15.
//

import Foundation

extension UIImage {
    func resizedImage(for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIColor {
    static let iconBlue = UIColor(red: 74/255, green: 119/255, blue: 245/255, alpha: 1.0)
}
