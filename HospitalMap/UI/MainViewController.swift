//
//  MainViewController.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/10.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, MTMapViewDelegate {

    private var mapView: MTMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MTMapView(frame: view.bounds)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            view.addSubview(mapView)
        }
    }


}

