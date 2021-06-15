//
//  MainViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/10.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let showListButton = UIButton()
    private let currentLocationButton = UIButton()

    private var mapView: MTMapView?
    private var choiceDeptView: ChoiceDeptView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupMapView()
        setupChoiceDeptView()
        setupShowListButton()
        setupCurrentLocationButton()
        
        //TODO: - 로딩 뷰 구현
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
    
    private func setupShowListButton() {
        showListButton.backgroundColor = UIColor.white
        showListButton.layer.cornerRadius = 7
        showListButton.layer.borderColor = UIColor.blue.cgColor
        showListButton.layer.borderWidth = 1
        
        showListButton.setTitle("병원 목록 보기", for: .normal)
        showListButton.setTitleColor(UIColor.black, for: .normal)
        showListButton.addTarget(self, action: #selector(showListButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(showListButton)
        
        showListButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(50)
        }
    }
    
    private func setupCurrentLocationButton() {
        currentLocationButton.backgroundColor = UIColor.white
        currentLocationButton.layer.cornerRadius = 7
        currentLocationButton.layer.borderColor = UIColor.blue.cgColor
        currentLocationButton.layer.borderWidth = 1
        
        if let image = UIImage.init(named: "SF_scope") {
            let imageSize: CGSize = CGSize(width: 30, height: 30)
            let resizedImage = image.resizedImage(for: imageSize)
                .withRenderingMode(.alwaysTemplate)
            currentLocationButton.setImage(resizedImage, for: .normal)
        }
        currentLocationButton.tintColor = UIColor.blue
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(currentLocationButton)
        
        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.bottom.equalTo(showListButton.snp.top).offset(-10)
            make.width.height.equalTo(50)
        }
    }
    
    //TODO: - 버튼 각 기능 구현
    @objc private func choiceDeptViewDidTapped() {
        print("초이스뷰 누름")
    }
    
    @objc private func showListButtonDidTapped() {
        print("목록보기 버튼 누름")
    }
    
    @objc private func currentLocationButtonDidTapped() {
        print("현재위치 버튼 누름")
    }
}

extension MainViewController: MTMapViewDelegate {
    
}

