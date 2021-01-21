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
    var currentScore = 0
    var actionToSend: Data?
    var home: HomeViewController
    
    var startGame = true
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    
    init(peripheral: CBPeripheral, home: HomeViewController) {
        self.home = home
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
    
    override func viewDidAppear(_ animated: Bool) {
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
        }
    }

    @IBAction func touchYellowButton(_ sender: Any) {
        self.actionToSend = Data("y".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
            enableActionButtonAfterPress(state: false)
        }
    }
    @IBAction func touchGreenButton(_ sender: Any) {
        self.actionToSend = Data("g".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
            enableActionButtonAfterPress(state: false)
        }
    }
    @IBAction func touchBlueButton(_ sender: Any) {
        self.actionToSend = Data("b".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
            enableActionButtonAfterPress(state: false)
        }
    }
    @IBAction func touchRedButton(_ sender: Any) {
        self.actionToSend = Data("r".utf8)
        if let serv = self.service {
            peripheral.discoverCharacteristics([Constants.CHARAC_UUID], for: serv)
            enableActionButtonAfterPress(state: false)
        }
    }
    
    func enableActionButtonAfterPress(state: Bool) {
        redButton.isEnabled = state
        blueButton.isEnabled = state
        greenButton.isEnabled = state
        yellowButton.isEnabled = state
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
            if startGame {
                let startMsg = Data("start".utf8)
                peripheral.writeValue(startMsg, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
                startGame = false
            }
            if let actionToSend = self.actionToSend {
                peripheral.writeValue(actionToSend, for: characteristic, type: CBCharacteristicWriteType.withoutResponse) // Send the msg to the device
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let recievedValue = characteristic.value {
            let recievedMsg = String(decoding: recievedValue, as: UTF8.self)
            print(recievedMsg)
            if recievedMsg == "r" || recievedMsg == "b" || recievedMsg == "g" || recievedMsg == "y" {
                enableActionButtonAfterPress(state: true)
            } else if recievedMsg.contains("trk:") {
                let extractedScoreValue = recievedMsg.components(separatedBy: ":")
                scoreValueLabel.text = extractedScoreValue[1]
                if let score = Int(extractedScoreValue[1]) {
                    currentScore = score
                }
            } else if recievedMsg == "lost" {
                let defaults = UserDefaults.standard
                defaults.set("\(currentScore + 25)", forKey: "highscore")
                home.setScoreLabelFromUsersDefault()
                dismiss(animated: true)
            }
        }
    }
}
