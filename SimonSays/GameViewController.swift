//
//  GameViewController.swift
//  SimonSays
//
//  Created by lexinor on 05/01/2021.
//

import UIKit
import CoreBluetooth

class GameViewController: UIViewController, CBPeripheralDelegate {
    var peripheral : CBPeripheral
    var characteristic : CBCharacteristic?
    var service: CBService?
    
    var actionToSend: Data?
    
    init(peripheral: CBPeripheral) {
        
        self.peripheral = peripheral
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        peripheral.delegate = self
        peripheral.discoverServices([Constants.SERVICE_UUID])
        // Do any additional setup after loading the view.
    }

    @IBAction func touchYellowButton(_ sender: Any) {
        self.actionToSend = Data("y".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
        }
    }
    @IBAction func touchGreenButton(_ sender: Any) {
        self.actionToSend = Data("g".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
        }
    }
    @IBAction func touchBlueButton(_ sender: Any) {
        self.actionToSend = Data("b".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
        }
    }
    @IBAction func touchRedButton(_ sender: Any) {
        self.actionToSend = Data("r".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let service = peripheral.services?.first(where: {$0.uuid == Constants.SERVICE_UUID }) {
            self.service = service
            // peripheral.discoverCharacteristics([Constants.characUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristic = service.characteristics?.first(where: { $0.uuid == Constants.CHARAC_UUID }) {
            peripheral.setNotifyValue(true, for: characteristic)
            self.characteristic = characteristic
            if let actionToSend = self.actionToSend {
                peripheral.writeValue(actionToSend, for: characteristic, type: CBCharacteristicWriteType.withoutResponse) // Send the msg to the device
                
                print(peripheral.readValue(for: characteristic))
            }
             
            
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let recievedValue = characteristic.value {
            let str = String(decoding: recievedValue, as: UTF8.self)
            print(str)
        }
    }
}
