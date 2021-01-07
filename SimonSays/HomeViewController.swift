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
    
    let serviceUUID = CBUUID(string: "FFE0")
    let characUUID = CBUUID(string: "FFE1")
    
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
            
            peripheral.delegate = self
            peripheral.discoverServices([serviceUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        pairingStatusLabel.text = Constants.PERIPHERAL_OFF
        pairingStatusLabel.textColor = .systemRed
        startPlayButton.isHidden = true
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let service = peripheral.services?.first(where: {$0.uuid == serviceUUID }) {
            peripheral.discoverCharacteristics([characUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristic = service.characteristics?.first(where: { $0.uuid == characUUID }) {
            peripheral.setNotifyValue(true, for: characteristic)
            arduino = peripheral
            //let test = Data("b".utf8) data example str to data
            //peripheral.writeValue(test, for: characteristic, type: CBCharacteristicWriteType.withoutResponse) // Send the msg to the device
            //print(peripheral.readValue(for: characteristic))
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let recievedValue = characteristic.value{
            let str = String(decoding: recievedValue, as: UTF8.self)
            //print(str)
        }
    }
}
