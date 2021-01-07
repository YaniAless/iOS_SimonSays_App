//
//  HomeViewController.swift
//  SimonSays
//
//  Created by lexinor on 05/01/2021.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {
    
    var cbCentralManager : CBCentralManager!
    var arduino : CBPeripheral?
    
    @IBOutlet weak var pairingStatusLabel: UILabel!
    @IBOutlet weak var startPlayButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        cbCentralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        startPlayButton.isHidden = true
    }

    @IBAction func touchPlayButton(_ sender: Any) {
        guard let arduino = self.arduino else { return }
        
        self.present(GameViewController(peripheral: arduino), animated: true)
        
    }
    
    func updateUIWithManagerState(state: CBManagerState) {
        switch state {
        case .poweredOn:
            pairingStatusLabel.text = Constants.PAIRING_MSG
        default:
            print("toto")
            pairingStatusLabel.text = Constants.BLUETOOTH_OFF_MSG
            pairingStatusLabel.textColor = .systemRed
        }
    }
    
}

// BLUETOOTH
extension HomeViewController : CBCentralManagerDelegate, CBPeripheralDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        updateUIWithManagerState(state: central.state)
        
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Looking for SimonModule..")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else { return }

        if peripheral.name == Constants.MODULE_NAME {
            cbCentralManager = central
            cbCentralManager.stopScan()
            cbCentralManager.connect(peripheral, options: nil)
            self.arduino = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        if peripheral.state == .connected {
            print("Connected to \(Constants.MODULE_NAME)")
            pairingStatusLabel.text = Constants.PAIRED_MSG
            pairingStatusLabel.textColor = .systemGreen
            startPlayButton.isHidden = false
            self.arduino = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(error.debugDescription)
        pairingStatusLabel.text = Constants.PERIPHERAL_OFF
        pairingStatusLabel.textColor = .systemRed
        startPlayButton.isHidden = true
    }
     
}
