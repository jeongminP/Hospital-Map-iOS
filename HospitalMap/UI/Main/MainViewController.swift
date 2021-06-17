//
//  MainViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/10.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let choiceDeptView = ChoiceDeptView()
    private let showListButton = UIButton()
    private let currentLocationButton = UIButton()
    private let pickerView = UIPickerView()
    private let infoView = InfoView()
    private let departmendCodeArr = DepartmendCode.allCases
    
    private var mapView: MTMapView?
    private var tmpSelectedRow: Int = 0
    private var currentDept: DepartmendCode = .IM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupMapView()
        setupChoiceDeptView()
        setupPickerView()
        setupShowListButton()
        setupCurrentLocationButton()
        setupInfoView()
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
        choiceDeptView.tintColor = UIColor.clear
        view.addSubview(choiceDeptView)
        
        choiceDeptView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(70)
        }
    }
    
    private func setupPickerView() {
        // 피커뷰 추가
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.systemGray6
        choiceDeptView.inputView = pickerView
        
        // 툴바 추가
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(self.pickerViewDoneDidTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.pickerViewCancelDidTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        choiceDeptView.inputAccessoryView = toolBar
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
    
    private func setupInfoView() {
        view.addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(150)
        }
    }
    
    @objc private func pickerViewDoneDidTapped() {
        currentDept = departmendCodeArr[tmpSelectedRow]
        choiceDeptView.setDeptLabel(to: currentDept.departmentName)
        choiceDeptView.resignFirstResponder()
        
        //TODO: - API 다시 요청
    }

    @objc private func pickerViewCancelDidTapped() {
        choiceDeptView.resignFirstResponder()
        tmpSelectedRow = departmendCodeArr.firstIndex(of: currentDept) ?? 0
        pickerView.selectRow(tmpSelectedRow, inComponent: 0, animated: false)
    }
    
    @objc private func showListButtonDidTapped() {
        print("목록보기 버튼 누름")
    }
    
    @objc private func currentLocationButtonDidTapped() {
        print("현재위치 버튼 누름")
        //TODO: - 현재 위치로 이동하는 로직 구현
    }
}

extension MainViewController: MTMapViewDelegate {
    
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departmendCodeArr[row].departmentName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tmpSelectedRow = row
    }
}

extension MainViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departmendCodeArr.count
    }
}
