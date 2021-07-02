//
//  MainViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/10.
//

import UIKit
import SnapKit
import Alamofire
import CoreLocation

class MainViewController: UIViewController {
    
    //MARK: - Private Properties - UI
    private let choiceDeptView = ChoiceDeptView()
    private let emdView = UIButton()
    private let showListButton = UIButton()
    private let currentLocationButton = UIButton()
    private let pickerView = UIPickerView()
    private let infoView = InfoView()
    private var mapView: MTMapView?
    private var loadingView: LoadingView?
    
    //MARK: - Private Properties - Kakao Map
    private var currentLocation: MTMapPoint?
    private var reverseGeoCoder: MTMapReverseGeoCoder?
    private var centerEMDong = ""
    private var lastSelectedItem: MTMapPOIItem?
    
    //MARK: - Private Properties
    private let dbManager = HospitalDBManager()
    private let departmendCodeArr = DepartmendCode.allCases
    private let userDefaultsCurrentDeptKey = "userDefaultsCurrentDeptKey"
    private var currentDept: DepartmendCode = .IM
    private var tmpSelectedRow: Int = 0
    private var hospitalItemList: [HospitalInfo] = [] {
        didSet {
            didSetHospitalItemList()
        }
    }
    
    fileprivate class POIItemUserObject<T: SearchResultItemType>: NSObject {
        let item: T
        
        init(item: T) {
            self.item = item
            super.init()
        }
    }
    
    //MARK: - Internal Methods
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
        setupLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Private Methods
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
        
        if let storedDeptCode = UserDefaults.standard.string(forKey: userDefaultsCurrentDeptKey),
           let storedDept = DepartmendCode(rawValue: storedDeptCode) {
            currentDept = storedDept
            choiceDeptView.setDeptLabel(to: currentDept.departmentName)
        }
    }
    
    private func setupPickerView() {
        // 피커뷰 추가
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.systemGray6
        pickerView.selectRow(departmendCodeArr.firstIndex(of: currentDept) ?? 0, inComponent: 0, animated: true)
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
        emdView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.7)
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
        showListButton.isUserInteractionEnabled = false
        
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
        infoView.delegate = self
        let infoViewTap = UITapGestureRecognizer(target: self, action: #selector(infoViewDidTapped))
        infoView.addGestureRecognizer(infoViewTap)
        view.addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        infoView.isHidden = true
    }
    
    private func setupLoadingView() {
        loadingView = LoadingView(frame: view.bounds)
        guard let loadingView = loadingView else {
            return
        }
        view.addSubview(loadingView)
        loadingView.stopLoading()
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Private Methods - Actions
    @objc private func pickerViewDoneDidTapped() {
        infoView.isHidden = true
        currentDept = departmendCodeArr[tmpSelectedRow]
        choiceDeptView.setDeptLabel(to: currentDept.departmentName)
        UserDefaults.standard.set(currentDept.rawValue, forKey: userDefaultsCurrentDeptKey)
        choiceDeptView.resignFirstResponder()
        
        // DB 쿼리 재실행
        fetchHospitalList(deptCode: currentDept, emdongName: centerEMDong)
    }

    @objc private func pickerViewCancelDidTapped() {
        choiceDeptView.resignFirstResponder()
        tmpSelectedRow = departmendCodeArr.firstIndex(of: currentDept) ?? 0
        pickerView.selectRow(tmpSelectedRow, inComponent: 0, animated: false)
    }
    
    @objc private func showListButtonDidTapped() {
        // 목록화면으로 이동
        let hospitalTableVC = HospitalTableViewController(hospitalList: hospitalItemList, emdongName: centerEMDong, deptName: currentDept.departmentName)
        navigationController?.pushViewController(hospitalTableVC, animated: true)
    }
    
    @objc private func currentLocationButtonDidTapped() {
        guard let location = currentLocation else {
            return
        }
        mapView?.setMapCenter(location, animated: true)
    }
    
    @objc private func infoViewDidTapped() {
        // 상세화면으로 이동
        guard let item = infoView.hospitalInfo else {
            return
        }
        let detailVC = DetailViewController(hospitalInfoItem: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: - Private Methods - DB Accessing
    private func fetchHospitalList(deptCode: DepartmendCode, emdongName: String) {
        loadingView?.startLoading()
        dbManager.getHospitalList(clCd: deptCode.rawValue, emdongNm: emdongName) { [weak self] hospitalList, success in
            guard success else {
                return
            }
            DispatchQueue.main.async {
                self?.hospitalItemList = hospitalList
            }
        }
    }
    
    private func fetchDepartments(ykiho: String, clCdNm: String) {
        dbManager.getDgsbjtList(ykiho: ykiho) { [weak self] dgsbjtList, success in
            guard let strongSelf = self else {
                return
            }
            var dgsbjtStr = dgsbjtList.reduce("") {
                $0 + $1 + ", "
            }
            if !dgsbjtStr.isEmpty {
                let range = dgsbjtStr.index(dgsbjtStr.endIndex, offsetBy: -2)..<dgsbjtStr.endIndex
                dgsbjtStr.removeSubrange(range)
            }
            DispatchQueue.main.async {
                strongSelf.infoView.setCodeNameLabel(clCdNm: clCdNm, dgsbjtStr: dgsbjtStr)
            }
        }
    }
    
    private func didSetHospitalItemList() {
        loadingView?.stopLoading()
        showListButton.setTitle("병원 목록 보기 (\(hospitalItemList.count))", for: .normal)
        showListButton.isUserInteractionEnabled = true
        
        // empty 시 토스트 메시지 표시
        if hospitalItemList.isEmpty {
            showToast(message: "일치하는 결과가 없습니다.")
        }
        
        mapView?.removeAllPOIItems()
        for idx in 0..<hospitalItemList.count {
            let item = hospitalItemList[idx]
            guard let xPos = item.getXPos(),
                  let yPos = item.getYPos() else {
                continue
            }
            let marker = MTMapPOIItem()
            marker.itemName = item.hospName
            marker.tag = idx
            marker.userObject = POIItemUserObject(item: item)
            marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: yPos, longitude: xPos))
            marker.markerType = .bluePin
            marker.markerSelectedType = .redPin
            marker.showAnimationType = .springFromGround
            mapView?.add(marker)
        }
    }
    
    private func showToast(message : String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .darkGray
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 20
        
        present(alert, animated: true)
        
        // 1초 후 dismiss
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alert.dismiss(animated: true)
        }
    }
    
    private func distance(from: MTMapPointGeo, to:MTMapPointGeo) -> Double {
        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLoc.distance(from: toLoc) / 1000
    }
}

//MARK: - InfoViewDelegate
extension MainViewController: InfoViewDelegate {
    func infoView(_ infoView: InfoView, didTappedTelNoView telNoView: UIView, of hospitalInfo: HospitalInfo) {
        guard let telNo = hospitalInfo.telNo,
              let url = URL(string: "tel://" + telNo) else {
            return
        }
        
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: { success in })
    }
    
    func infoView(_ infoView: InfoView, didTappedHospUrlView hospUrlView: UIView, of hospitalInfo: HospitalInfo) {
        guard let hospUrl = hospitalInfo.hospUrl,
              let url = URL(string: hospUrl) else {
            return
        }
        
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: { success in })
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
    
    func mapView(_ mapView: MTMapView?, selectedPOIItem poiItem: MTMapPOIItem?) -> Bool {
        guard let hospItem = (poiItem?.userObject as? POIItemUserObject<HospitalInfo>)?.item,
              let clCdNm = hospItem.classCodeName,
              let ykiho = hospItem.ykiho else {
            return false
        }
        
        // DB에서 진료과 검색
        fetchDepartments(ykiho: ykiho, clCdNm: clCdNm)
        
        // 거리 계산
        var dist: Double?
        if let curLocGeo = currentLocation?.mapPointGeo(),
           let xPos = hospItem.getXPos(),
           let yPos = hospItem.getYPos() {
            dist = distance(from: curLocGeo, to: MTMapPointGeo(latitude: yPos, longitude: xPos))
        }
        
        // infoView 표시
        infoView.setHospitalInfo(item: hospItem, distance: dist)
        infoView.isHidden = false
        return true
    }
    
    func mapView(_ mapView: MTMapView?, touchedCalloutBalloonOf poiItem: MTMapPOIItem?) {
        // 상세화면으로 이동
        guard let item = (poiItem?.userObject as? POIItemUserObject<HospitalInfo>)?.item else {
            return
        }
        let detailVC = DetailViewController(hospitalInfoItem: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - MTMapReverseGeoCoderDelegate
extension MainViewController: MTMapReverseGeoCoderDelegate {
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder?, foundAddress addressString: String?) {
        guard let addrStr = addressString,
              let newEMDong = parseEMDongNm(from: addrStr),
              centerEMDong != newEMDong else {
            loadingView?.stopLoading()
            reverseGeoCoder = nil
            return
        }
        
        centerEMDong = newEMDong
        emdView.setTitle(centerEMDong, for: .normal)
        fetchHospitalList(deptCode: currentDept, emdongName: centerEMDong)
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
