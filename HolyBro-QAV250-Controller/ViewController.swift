//
//  ViewController.swift
//  MAVSDK-Swift-Starter-App
//
//  Created by unipheas on 8/29/19.
//  Copyright © 2019 Brian Phillips. All rights reserved.
//

import UIKit
import MAVSDK_Swift
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var armBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        _ = drone.startMavlink.subscribe(onCompleted: {
            _ = drone.core.connectionState
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { connectionState in
                    if connectionState.isConnected {
                        self.statusLbl.text = "Status: Connected"
                    } else {
                        self.statusLbl.text = "Satus: Disconnected"
                    }
                })
        })
    }

    @IBAction func armBtnPressed(_ sender: Any) {
        
        if self.armBtn.titleLabel?.text == "Disarm" {
            _ = drone.action.disarm()
                .do(onError: { (error) in
                    self.statusLbl.text = "Status: Disarming Failed"
                }, onCompleted: {
                    self.statusLbl.text = "Status: Disarmed"
                    self.armBtn.setTitle("Arm", for: .normal)
                }).subscribe()
        } else {
            _ = drone.action.arm()
                .do(onError: { (error) in
                    self.statusLbl.text = "Status: Arming Failed"
                }, onCompleted: {
                    self.statusLbl.text = "Status: Armed"
                    self.armBtn.setTitle("Disarm", for: .normal)
                }).subscribe()
        }
        
    }
    

}

