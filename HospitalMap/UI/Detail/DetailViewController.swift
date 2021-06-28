//
//  DetailViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let hospitalInfo: HospitalInfo
    private var loadingView: LoadingView?
    
    init(hospitalInfoItem: HospitalInfo) {
        self.hospitalInfo = hospitalInfoItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        navigationController?.isNavigationBarHidden = false
        title = hospitalInfo.hospName
        view.backgroundColor = .systemGray5
    }
}
