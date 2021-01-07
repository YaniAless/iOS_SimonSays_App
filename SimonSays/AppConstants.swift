//
//  AppConstants.swift
//  SimonSays
//
//  Created by lexinor on 05/01/2021.
//

import Foundation
import CoreBluetooth

struct Constants {
    
    static let MODULE_NAME = "SimonModule\r\n"
    static let PAIRING_MSG = "Pairing to the device..."
    static let PAIRED_MSG = "Connected to the device"
    static let BLUETOOTH_OFF_MSG = "Please turn on bluetooth"
    static let PERIPHERAL_OFF = "Peripheral's connection lost,\n please reconnect.."
    
    static let SERVICE_UUID = CBUUID(string: "FFE0")
    static let CHARAC_UUID = CBUUID(string: "FFE1")
    
}
