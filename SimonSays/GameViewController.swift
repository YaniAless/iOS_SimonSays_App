//
//  GameViewController.swift
//  SimonSays
//
//  Created by lexinor on 05/01/2021.
//

import UIKit
import CoreBluetooth

class GameViewController: UIViewController {
    var peripheral : CBPeripheral
    
    init(peripheral: CBPeripheral) {
        
        self.peripheral = peripheral
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func touchYellowButton(_ sender: Any) {
        
    }
    @IBAction func touchGreenButton(_ sender: Any) {
    }
    @IBAction func touchBlueButton(_ sender: Any) {
    }
    @IBAction func touchRedButton(_ sender: Any) {
    }
}
