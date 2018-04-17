//
//  ViewController.swift
//  findDifferent
//
//  Created by JTDX on 2018/3/13.
//  Copyright © 2018年 JTDX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var images : Array<UIImage> = [
        UIImage(named: "bee.png")!,
        UIImage(named: "bird.png")!,
        UIImage(named: "flower.png")!,
        UIImage(named: "mogu.png")!
    ];
    
    var cords : Array<CGPoint> = [];
    var errorCords: Array<CGPoint> = [];
    var foundIndex: Array<Int> = [];
    
    var width : CGFloat!;
    var height: CGFloat!;
    
    var startTime : Int = 0;
    var endTime : Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let iv1 = self.view.viewWithTag(1001) as! UIImageView;
        let iv2 = self.view.viewWithTag(1002) as! UIImageView;
        iv1.isUserInteractionEnabled = true;
        iv2.isUserInteractionEnabled = true;
        width = iv1.frame.size.width - 40;
        height = iv1.frame.size.height - 40;
        
        while (cords.count < 10) {
            let x = CGFloat(arc4random() % UInt32(width));
            let y = CGFloat(arc4random() % UInt32(height));
            var flag = 0;
            for each in cords
            {
                if ((each.x == x) && (each.y == y))
                {
                    flag = 1;
                    break;
                }
            }
            if (flag == 0)
            {
                cords.append(CGPoint(x: x, y: y));
            }
        }
        
        while (errorCords.count < 3) {
            let x = CGFloat(arc4random() % UInt32(width));
            let y = CGFloat(arc4random() % UInt32(height));
            var flag = 0;
            for each in errorCords
            {
                if ((each.x == x) && (each.y == y))
                {
                    flag = 1;
                    break;
                }
            }
            if (flag == 0)
            {
                errorCords.append(CGPoint(x: x, y: y));
            }
        }
        
        for each in cords
        {
            let size = CGSize(width: 40, height: 40);
            let rect = CGRect(origin: each, size: size);
            let imgView1 = UIImageView(frame: rect);
            let imgView2 = UIImageView(frame: rect);
            let index = Int(arc4random()) % images.count;
            imgView1.image = images[index];
            imgView2.image = images[index];
            iv1.addSubview(imgView1);
            iv2.addSubview(imgView2);
        }
        
        for (index, each) in errorCords.enumerated()
        {
            let size = CGSize(width: 40, height: 40);
            let rect = CGRect(origin: each, size: size);
            let btn1 = UIButton(frame: rect);
            let btn2 = UIButton(frame: rect);
            let rand = Int(arc4random() % 4);
            if (rand >= 2)
            {
                btn1.setImage(UIImage(named: "empty.png"), for: UIControlState.normal);
                let index = Int(arc4random()) % images.count;
                btn2.setImage(images[index], for: UIControlState.normal);
            }
            else
            {
                btn2.setImage(UIImage(named: "empty.png"), for: UIControlState.normal);
                let index = Int(arc4random()) % images.count;
                btn1.setImage(images[index], for: UIControlState.normal);
            }
            btn1.isUserInteractionEnabled = true;
            btn2.isUserInteractionEnabled = true;
            btn1.addTarget(self, action: #selector(doAction(_:)), for: UIControlEvents.touchUpInside);
            btn2.addTarget(self, action: #selector(doAction(_:)), for:
                UIControlEvents.touchUpInside);
            btn1.tag = 9000 + index;
            btn2.tag = 8000 + index;
            
            iv1.addSubview(btn1);
            iv2.addSubview(btn2);
        }
    }
    
    @objc func doAction (_ sender: UIButton)
    {
        let output = self.view.viewWithTag(1003) as! UILabel;
        output.text = "found: \(sender.tag)";
        print("found: \(sender.tag)");
        var value: Int!;
        if (sender.tag >= 9000)
        {
            value = sender.tag - 9000;
            for each in foundIndex
            {
                if each == value
                {
                    return;
                }
            }
            foundIndex.append(value);
            if foundIndex.count == 3
            {
                let now = Date();
                let timeInterval: TimeInterval = now.timeIntervalSince1970;
                endTime = Int(timeInterval);
                print("All found, use \(endTime - startTime) Seconds");
                output.text = "All found, use \(endTime - startTime) Seconds";
            }
        }
        else if (sender.tag >= 8000)
        {
            value = sender.tag - 8000
            for each in foundIndex
            {
                if each == value
                {
                    return;
                }
            }
            foundIndex.append(value);
            if (foundIndex.count == 3)
            {
                let now = Date();
                let timeInterval: TimeInterval = now.timeIntervalSince1970;
                endTime = Int(timeInterval);
                print("All found, use \(endTime - startTime) Seconds");
                output.text = "All found, use \(endTime - startTime) Seconds";
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let now = Date();
        let timeInterval: TimeInterval = now.timeIntervalSince1970;
        startTime = Int(timeInterval);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

