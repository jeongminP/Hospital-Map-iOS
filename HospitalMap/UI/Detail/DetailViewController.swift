//
//  DetailViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/25.
//

import UIKit
import SnapKit
import Alamofire

class DetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var basicInfoView: BasicInfoView?
    private var loadingView: LoadingView?
    
    private let hospitalInfo: HospitalInfo
    private var hospitalDetailInfo: HospDetailInfo? {
        didSet {
            didSetHospitalDetailInfo()
        }
    }
    
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
        if let ykiho = hospitalInfo.ykiho {
            requestHospitalDetailInfo(ykiho: ykiho)
        }
    }
    
    private func setupLayout() {
        navigationController?.isNavigationBarHidden = false
        title = hospitalInfo.hospName
        view.backgroundColor = .systemGray5
        
        setupScrollableStackView()
        setupLoadingView()
    }
    
    private func setupScrollableStackView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.trailing.equalToSuperview().offset(-10)
        }
        
        basicInfoView = BasicInfoView(frame: view.bounds, hospitalInfoItem: self.hospitalInfo)
        guard let basicInfoView = basicInfoView else {
            return
        }
        stackView.addArrangedSubview(basicInfoView)
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
    
    //MARK: - Networking Method
    private func requestHospitalDetailInfo(ykiho: String) {
        loadingView?.startLoading()
        let urlString = "http://apis.data.go.kr/B551182/medicInsttDetailInfoService/getDetailInfo?pageNo=1&numOfRows=50&_type=json"
            + "&ykiho=" + ykiho
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = URL(string: encodedStr + "&ServiceKey=Q%2BbQw%2FUNPpDxP9hAGr3SQzR71t%2BCRCoDcFtPYmxVpEdlObYNjUINxMD3hurNngT3r19ae%2FDHw7t%2B5YhzIm2EuA%3D%3D") else
        {
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseData { response in
                defer {
                    self.loadingView?.stopLoading()
                }
                switch response.result {
                case .success(let data):
                    do {
                        let res = try JSONDecoder().decode(ResponseStruct<HospDetailInfo>.self, from: data)
                        self.hospitalDetailInfo = res.response?.body?.items?["item"] ?? nil
                    } catch {
                        self.hospitalDetailInfo = nil
                        NSLog("%s", String(describing: error))
                    }
                case .failure(let e):
                    print(e)
                }
            }
    }
    
    private func didSetHospitalDetailInfo() {
        //TODO: - 상세 정보 표시
    }
}
