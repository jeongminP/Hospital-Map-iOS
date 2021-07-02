//
//  HospitalTableViewController.swift
//  HospitalMap
//
//  Created by parkbirdfly on 2021/06/24.
//

import UIKit
import SnapKit

class HospitalTableViewController: UIViewController {
    
    //MARK: - Private Properties - UI
    private let tableView = UITableView()
    private let emptyView = UIView()
    private let emptyLabel = UILabel()
    private let hospitalCellID = "HospitalTableViewCell"
    
    //MARK: - Private Properties
    private let hospitalList: [HospitalInfo]
    private let emdongName, deptName: String
    
    //MARK: - Internal Methods
    init(hospitalList: [HospitalInfo], emdongName: String, deptName: String) {
        self.hospitalList = hospitalList
        self.emdongName = emdongName
        self.deptName = deptName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    //MARK: - Private Method
    private func setupLayout() {
        navigationController?.isNavigationBarHidden = false
        self.title = emdongName + " " + deptName + " : \(hospitalList.count)건"
        
        // table view 구현
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray5
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let cell = UINib(nibName: hospitalCellID, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: hospitalCellID)
        
        // empty view 구현
        emptyLabel.text = "일치하는 검색 결과가 없습니다."
        emptyView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyView.backgroundColor = .systemGray5
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if !hospitalList.isEmpty {
            emptyView.isHidden = true
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HospitalTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세화면으로 이동
        guard hospitalList.count > indexPath.row else {
            return
        }
        let detailVC = DetailViewController(hospitalInfoItem: hospitalList[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HospitalTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: hospitalCellID, for: indexPath) as? HospitalTableViewCell,
              hospitalList.count > indexPath.row else {
            return UITableViewCell()
        }
        cell.setHospitalInfo(item: hospitalList[indexPath.row])
        return cell
    }
}
    
