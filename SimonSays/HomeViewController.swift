//
//  HomeViewController.swift
//  SimonSays
//
//  Created by lexinor on 05/01/2021.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var pairingStatusLabel: UILabel!
    @IBOutlet weak var startPlayButton: UIButton!
    
    var cbCentralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    let MODULE_NAME = "SimonModule\r\n"
    let PAIRING_MSG = "Pairing to the device..."
    let PAIRED_MSG = "Connected to the device"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cbCentralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        startPlayButton.isHidden = true
    }

    @IBAction func touchPlayButton(_ sender: Any) {
        guard let peripheral = peripheral else { return }
        
        self.present(GameViewController(peripheral: peripheral), animated: true)
        
    }
    
}
extension HomeViewController : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn){
            central.scanForPeripherals(withServices: nil, options: nil)
            print("scanning...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else { return }
        
        if peripheral.name == MODULE_NAME {
            cbCentralManager.stopScan()
            
            cbCentralManager.connect(peripheral, options: nil)
            self.peripheral = peripheral
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral.state == .connected {
            print("Connected to \(MODULE_NAME)")
            pairingStatusLabel.text = PAIRED_MSG
            pairingStatusLabel.textColor = .green
            startPlayButton.isHidden = false
        }
    }
    
}
