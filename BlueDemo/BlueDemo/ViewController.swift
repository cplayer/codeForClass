//
//  ViewController.swift
//  BlueDemo
//
//  Created by Zhifeng Chen on 2018/3/25.
//  Copyright © 2018年 Zhifeng Chen. All rights reserved.
//根据RSSI值，得到设备与手机之间的距离公式大概如下:powe(10, (abs(rssi) - 59) / (10 * 2.0)); 大概有这么一个关系，不是很准确。

import UIKit
import CoreBluetooth

class ViewController: UIViewController ,CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate{
    //variable
    var manager : CBCentralManager!
    var discoveredPeripherals : Array<CBPeripheral> = [] //查找后发现的所有设备数组
    var rssi : Array<NSNumber> = []
    
    var connectedPeripheral : CBPeripheral! //当前已连接设备
    var currentCharacteristic : CBCharacteristic! //当前的设备特性
    
    var lastString : String!
    var sendString : String!

    
    //需要连接的 CBCharacteristic的UUID
//    let ServiceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
    let ServiceUUID = "4FAFC201-1FB5-459E-8FCC-C5C9C331914B"
    
//    let CharacterUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"
    let CharacterUUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
    
    //outlet
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var tipsLabel: UILabel!
    
    
    //action
    @IBAction func onClicked(_ sender: UIButton) {
        discoveredPeripherals.removeAll()
        rssi.removeAll()
        myTable.reloadData()
        manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    @IBAction func onWritten(_ sender: UIButton) {
        if currentCharacteristic.properties.contains(.write){
            let str = "key"
            let data = str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            connectedPeripheral.writeValue(data, for: currentCharacteristic, type: .withResponse)
        }
        else {
            tipsLabel.text = "\(connectedPeripheral.name!)的\(currentCharacteristic.uuid)不可以写入"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CBCentralManager(delegate: self, queue: .main)
        myTable.dataSource = self
        myTable.delegate = self
    }

    //UITableView Delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredPeripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let peripheral = discoveredPeripherals[indexPath.row]
        if peripheral.name != nil {
            cell?.textLabel?.text = "设备名称：\(peripheral.name!)"
        }
        else {
            cell?.textLabel?.text = "设备名称：未知"
        }
        cell?.detailTextLabel?.text = "RSSI:\(rssi[indexPath.row])"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeripheral = discoveredPeripherals[indexPath.row]
        manager.connect(selectedPeripheral, options: nil)
    }
    

    //CBCentralManager Delegate
    //设备状态更新
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            tipsLabel.text = "Unknown"
        case .poweredOn:
            tipsLabel.text = "Power ON"
        case .poweredOff:
            tipsLabel.text = "Power OFF"
        case .unsupported:
            tipsLabel.text = "Unsupported"
        case .unauthorized:
            tipsLabel.text = "Unauthorized"
        case .resetting:
            tipsLabel.text = "Pedding for resetting"
        }
    }
    //设备扫描
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var isExisted = false
        for obtainedPeriphal in discoveredPeripherals {
            if obtainedPeriphal.identifier == peripheral.identifier {
                isExisted = true
                
            }
        }
        if !isExisted {
            discoveredPeripherals.append(peripheral)
            rssi.append(RSSI)
        }
        myTable.reloadData()
    }
    //设备连接
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        peripheral.discoverServices(nil) //开始扫描设备提供的service
        
        peripheral.delegate = self
        if let name = peripheral.name {
            tipsLabel.text = "已连接设备:\(name)"
        }
        else {
            tipsLabel.text = "已连接设备：未知"
        }
        manager.stopScan()
        DispatchQueue.main.async {
            peripheral.readRSSI()
        }
        
    }
    //设备连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let name = peripheral.name {
            tipsLabel.text = "连接设备：\(name)失败"
        }
        else {
            tipsLabel.text = "连接设备：未知 失败"
        }
    }
    //设备连接断开
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let name = peripheral.name {
            tipsLabel.text = "连接设备：\(name)已经断开"
        }
        else {
            tipsLabel.text = "连接设备：未知 已经断开"
        }
        manager.connect(peripheral, options: nil)  //重新连接
    }
    
    //CBPeripheralDelegate
    //扫描services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            tipsLabel.text = "设备\(peripheral.name!)扫描service出错，错误为：\(error!.localizedDescription)"
        }
        for service in peripheral.services! {
            if service.uuid.uuidString == ServiceUUID {
                tipsLabel.text = "找到设备\(peripheral.name!)提供的服务"
                peripheral.discoverCharacteristics(nil, for: service)
            }
            else {
                tipsLabel.text = "没有找到特定的服务"
            }
        }
    }
    //扫描characteristic
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            tipsLabel.text = "设备\(peripheral.name!)扫描characteristic时出错，错误为：\(error!.localizedDescription)"
        }
        
        for characteristic in service.characteristics! {
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic) //true表示接受广播
        }
    }
    //获取characteristic的值
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let resultStr = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
        tipsLabel.text = "characteristic uuid:\(characteristic.uuid),value:\(resultStr!)"
        currentCharacteristic = characteristic
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            tipsLabel.text = "设备\(peripheral.name!)在写入\(characteristic.uuid)时出错，错误为:\(error!.localizedDescription)"
        }
        else {
            tipsLabel.text = "设备\(peripheral.name!)写入\(characteristic.uuid)数据成功"
        }
    }
    //获取RSSI
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print(RSSI)
        print("RSSI")
    }
    

}

