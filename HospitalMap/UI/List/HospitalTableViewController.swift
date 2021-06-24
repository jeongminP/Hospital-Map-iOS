//
//  HospitalTableViewController.swift
//  HospitalMap
//
//  Created by parkbirdfly on 2021/06/24.
//

import UIKit
import SnapKit

class HospitalTableViewController: UIViewController {
    
    private let hospitalList: [HospitalInfo]
    private let emdongName, deptName: String
    private let tableView = UITableView()
    private let hospitalCellID = "HospitalTableViewCell"
    
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
        
        navigationController?.isNavigationBarHidden = false
        self.title = emdongName + " " + deptName + " : \(hospitalList.count)건"
        view.backgroundColor = .systemGray3
        tableView.backgroundColor = .systemGray3
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let cell = UINib(nibName: hospitalCellID, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: hospitalCellID)
    }
}

extension HospitalTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: - 상세화면으로 이동
    }
}

extension HospitalTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: hospitalCellID, for: indexPath) as? HospitalTableViewCell else {
            return UITableViewCell()
        }
        cell.setHospitalInfo(item: hospitalList[indexPath.row])
        return cell
    }
}
    
