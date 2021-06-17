//
//  MainViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/10.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    //MARK: - Private Properties - UI
    private let choiceDeptView = ChoiceDeptView()
    private let emdView = UIButton()
    private let showListButton = UIButton()
    private let currentLocationButton = UIButton()
    private let pickerView = UIPickerView()
    private let infoView = InfoView()
    private var mapView: MTMapView?
    
    //MARK: - Private Properties - Kakao Map
    private var currentLocation: MTMapPoint?
    private var reverseGeoCoder: MTMapReverseGeoCoder?
    private var centerEMDong = ""
    private var lastSelectedItem: MTMapPOIItem?
    
    //MARK: - Private Properties
    private let departmendCodeArr = DepartmendCode.allCases
    private var currentDept: DepartmendCode = .IM
    private var tmpSelectedRow: Int = 0
    private var hospitalItemList: [HospitalInfo] = []
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupMapView()
        setupChoiceDeptView()
        setupPickerView()
        setupEmdLabel()
        setupShowListButton()
        setupCurrentLocationButton()
        setupInfoView()
        
        //TODO: - 로딩 뷰 구현
        
    }
    
    private func setupMapView() {
        mapView = MTMapView(frame: view.bounds)
        guard let mapView = mapView else {
            return
        }
        mapView.delegate = self
        mapView.setZoomLevel(2, animated: true)
        mapView.baseMapType = .standard
        mapView.currentLocationTrackingMode = .onWithoutHeading
        mapView.showCurrentLocationMarker = true
        view.addSubview(mapView)
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
    
    private func setupEmdLabel() {
        emdView.backgroundColor = UIColor.gray
        emdView.layer.cornerRadius = 11.5
        emdView.tintColor = UIColor.white
        emdView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        emdView.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        emdView.isUserInteractionEnabled = false
        view.addSubview(emdView)
        
        emdView.snp.makeConstraints { make in
            make.top.equalTo(choiceDeptView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
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
    
    private func setupInfoView() {
        view.addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        infoView.isHidden = true
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
        guard let location = currentLocation else {
            return
        }
        mapView?.setMapCenter(location, animated: true)
    }
}

//MARK: - MTMapViewDelegate
extension MainViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView?, updateCurrentLocation location: MTMapPoint?, withAccuracy accuracy: MTMapLocationAccuracy) {
        currentLocation = location
        mapView?.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
    }
    
    func mapView(_ mapView: MTMapView?, singleTapOn mapPoint: MTMapPoint?) {
        infoView.isHidden = true
    }
    
    func mapView(_ mapView: MTMapView?, dragStartedOn mapPoint: MTMapPoint?) {
        infoView.isHidden = true
        if let item = lastSelectedItem {
            mapView?.deselect(item)
            lastSelectedItem = nil
        }
    }
    
    func mapView(_ mapView: MTMapView?, finishedMapMoveAnimation mapCenterPoint: MTMapPoint?) {
        guard let point = mapCenterPoint,
              let key = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String else {
            return
        }
        
        // 주소 찾기 시작
        // ARC 때문에 멤버로 할당해주어야 비동기 이벤트 처리 시까지 유지됨.
        reverseGeoCoder = MTMapReverseGeoCoder.init(mapPoint: point, with: self, withOpenAPIKey: key)
        reverseGeoCoder?.startFindingAddress()
    }
}

extension MainViewController: MTMapReverseGeoCoderDelegate {
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder?, foundAddress addressString: String?) {
        guard let addrStr = addressString,
              let newEMDong = parseEMDongNm(from: addrStr),
              centerEMDong != newEMDong else {
            
            //TODO: - 로딩뷰 숨기기
            
            reverseGeoCoder = nil
            return
        }
        
        centerEMDong = newEMDong
        emdView.setTitle(centerEMDong, for: .normal)
        reverseGeoCoder = nil
    }
    
    func mapView(_ mapView: MTMapView?, failedUpdatingCurrentLocationWithError error: Error?) {
        reverseGeoCoder = nil
        if let error = error {
            NSLog("%s", error.localizedDescription)
        }
    }
    
    private func parseEMDongNm(from addrStr: String) -> String? {
        let splitArr = addrStr.components(separatedBy: " ")
        for s in splitArr {
            let last = s[s.index(before: s.endIndex)]
            if last == "읍" || last == "면" || last == "동"
                || last == "로" || last == "길" || last == "가" {
                return s
            }
        }
        return nil
    }
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
