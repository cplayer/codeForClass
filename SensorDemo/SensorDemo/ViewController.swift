//
//  ViewController.swift
//  SensorDemo
//
//  Created by JTDX on 2018/4/3.
//  Copyright © 2018年 JTDX. All rights reserved.
//

import UIKit
import CoreMotion

class diyCell : UITableViewCell {
    var firstLabel : UILabel!;
    var secondLabel : UILabel!;
    var thirdLabel : UILabel!;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        let firstRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40);
        firstLabel = UILabel(frame: firstRect);
        firstLabel.font = UIFont.boldSystemFont(ofSize: 20);
        firstLabel.numberOfLines = 1;
        firstLabel.textAlignment = .right;
        self.addSubview(firstLabel);
        
        let secondRect = CGRect(x: 10, y: 30, width: self.frame.size.width, height: 60);
        secondLabel = UILabel(frame: secondRect);
        secondLabel.font = UIFont.boldSystemFont(ofSize: 15);
        secondLabel.numberOfLines = 1;
        secondLabel.textAlignment = .left;
        self.addSubview(secondLabel);
        
        let thirdRect = CGRect(x: 0, y: 95, width: self.frame.size.width, height: 30);
        thirdLabel = UILabel(frame: thirdRect);
        thirdLabel.font = UIFont.boldSystemFont(ofSize: 13);
        thirdLabel.numberOfLines = 1;
        thirdLabel.textAlignment = .right;
        self.addSubview(thirdLabel);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
}

struct sensorInfo : Codable {
    let name : String;
    let value : String;
    let time : String;
};

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let motionManager = CMMotionManager();
    var timer : Timer!;
    var timerForCell : Timer!;
    var sensorInfos : Array<sensorInfo> = [];
    var type : String = "null";

    @IBOutlet weak var myTableView: UITableView!;
    
    @IBAction func setTypeAcc(_ sender: DLRadioButton) {
        self.type = "Accelerometer";
    }
    
    @IBAction func setTypeGyro(_ sender: DLRadioButton) {
        self.type = "Gyro";
    }
    
    @IBAction func setTypeMag(_ sender: DLRadioButton) {
        self.type = "Magnetometer";
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        motionManager.startAccelerometerUpdates();
        motionManager.startGyroUpdates();
        motionManager.startMagnetometerUpdates();
        
        // timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true);
        
        myTableView.dataSource = self;
        myTableView.delegate = self;
        
        timerForCell = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(downloadRecords), userInfo: nil, repeats: true);
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensorInfos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diyCell(style: .default, reuseIdentifier: "Cell");
        let dict : sensorInfo = sensorInfos[indexPath.row];
        cell.firstLabel.text = dict.name;
        cell.secondLabel.text = dict.value;
        cell.thirdLabel.text = dict.time;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
    
    @objc func update () {
        if let accData = motionManager.accelerometerData {
            let s = "x:\(accData.acceleration.x),y:\(accData.acceleration.y),z:\(accData.acceleration.z)";
            print("Accelerometer => \(s)");
            let now = Date();
            let timeInterval : TimeInterval = now.timeIntervalSince1970;
            let timeStamp : Int = Int(timeInterval);
            let uploadString = "name='Accelerometer'&value='\(s)'&time='\(timeStamp)'";
            self.upload(getParameter : uploadString);
        }
        if let gyroData = motionManager.gyroData {
            let s = "x:\(gyroData.rotationRate.x),y:\(gyroData.rotationRate.y),z:\(gyroData.rotationRate.z)";
            print("Gyro => \(s)");
            let now = Date();
            let timeInterval : TimeInterval = now.timeIntervalSince1970;
            let timeStamp : Int = Int(timeInterval);
            let uploadString = "name='Gyro'&value='\(s)'&time='\(timeStamp)'";
            self.upload(getParameter : uploadString);
        }
        if let magData = motionManager.magnetometerData {
            let s = "x:\(magData.magneticField.x),y:\(magData.magneticField.y),z:\(magData.magneticField.z)";
            print("Magnetometer => \(s)");
            let now = Date();
            let timeInterval : TimeInterval = now.timeIntervalSince1970;
            let timeStamp : Int = Int(timeInterval);
            let uploadString = "name='Magnetometer'&value='\(s)'&time='\(timeStamp)'";
            self.upload(getParameter : uploadString);
        }
        
    }
    
    func upload (getParameter : String) {
        let requestString = "http://192.168.5.24:8080/gotoDB?" + getParameter;
        let url = URL(string: requestString);
        var request : URLRequest = URLRequest(url: url!);
        request.httpMethod = "GET";
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error!)")
                return
            }
            let httpStatus = response as? HTTPURLResponse;
            if (httpStatus?.statusCode != 200) {
                print("Error with code \(httpStatus!.statusCode)");
            }
        
            let responseString = String(data: data, encoding: .utf8)!;
            print(responseString);
        });
        task.resume();
    }
    
    @objc func downloadRecords () {
        let requestString = "http://192.168.5.24:8080/getDB";
        let url = URL(string: requestString);
        var request : URLRequest = URLRequest(url: url!);
        request.httpMethod = "GET";
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error!)")
                return
            }
            let httpStatus = response as? HTTPURLResponse;
            if (httpStatus?.statusCode != 200) {
                print("Error with code \(httpStatus!.statusCode)");
            }
            
            let responseString = String(data: data, encoding: .utf8)!;
            print(responseString);
            let decoder = JSONDecoder();
            let info = try! decoder.decode([sensorInfo].self, from: data);
            self.sensorInfos.removeAll();
            if (self.type == "null") {
                for element in info {
                    self.sensorInfos.append(element);
                }
            } else {
                for element in info {
                    if (element.name == self.type) {
                        self.sensorInfos.append(element);
                    }
                }
            }
            DispatchQueue.main.async {
                self.myTableView.reloadData();
            }
        });
        task.resume();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

