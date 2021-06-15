//
//  MainViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/10.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private var mapView: MTMapView?
    private var choiceDeptView: ChoiceDeptView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupMapView()
        setupChoiceDeptView()
    }

    private func setupMapView() {
        mapView = MTMapView(frame: view.bounds)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            view.addSubview(mapView)
        }
    }
    
    private func setupChoiceDeptView() {
        choiceDeptView = ChoiceDeptView(frame: view.bounds)
        if let choiceDeptView = choiceDeptView {
            choiceDeptView.addTarget(self, action: #selector(choiceDeptViewDidTapped), for: .touchUpInside)
            view.addSubview(choiceDeptView)
            
            choiceDeptView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
                make.height.equalTo(70)
            }
        }
    }
    
    @objc private func choiceDeptViewDidTapped() {
        print("초이스뷰 누름")
    }
}

extension MainViewController: MTMapViewDelegate {
    
}

