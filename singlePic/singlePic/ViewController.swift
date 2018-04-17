//
//  ViewController.swift
//  singlePic
//
//  Created by JTDX on 2018/3/6.
//  Copyright © 2018年 JTDX. All rights reserved.
//

import UIKit

import AVFoundation

@objcMembers
class ViewController: UIViewController {
    
    var soundPlayer: AVAudioPlayer!;
    var endX : CGFloat?;

    @IBAction func hideMenu(_ sender: UIButton) {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(hideMenuFunc), userInfo: nil, repeats: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myImageView = self.view.viewWithTag(1001) as! UIImageView;
        var imgArr : Array<UIImage> = [];
        for i in 1..<9 {
            let img = UIImage(named: "\(i).png")!;
            imgArr.append(img);
        }
        let img = UIImage.animatedImage(with: imgArr, duration: 1);
        myImageView.image = img;
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(doTimer), userInfo: nil, repeats: true);
        
        let menuv = self.view.viewWithTag(1000)!;
        endX = menuv.frame.origin.x;
        menuv.frame.origin.x = -20;
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(doMenu), userInfo: nil, repeats: true);
        
        let menuImageView = self.view.viewWithTag(1002) as! UIImageView;
        menuImageView.image = img;
        
    }
    
    func doTimer () {
        let iv = self.view.viewWithTag(1001)!;
        UIView.animate(withDuration: 2, animations: {
            iv.transform = iv.transform.rotated(by: CGFloat(360));
        });
        
    }
    func doMenu () {
        let menuv = self.view.viewWithTag(1000)!;
        
        UIView.animate(withDuration: 0.1, animations: {
            if (menuv.frame.origin.x < self.endX!) {
                menuv.frame.origin.x += 10;
            }
        });
    }
    func hideMenuFunc () {
        let menuv = self.view.viewWithTag(1000)!;
        UIView.animate(withDuration: 0.1, animations: {
            if (menuv.frame.origin.x > -20) {
                menuv.frame.origin.x -= 10;
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onClicked(_ sender: UIButton) {
        let myTitle = sender.currentTitle!;
        print (myTitle);
        var title: String;
        switch (myTitle) {
        case "mao":
            title = "mao.wav";
        case "gou":
            title = "gou.mp3";
        default:
            title = "";
        }

        let path = Bundle.main.path(forResource: title, ofType: nil);
        let url = URL(fileURLWithPath: path!);
        soundPlayer = try? AVAudioPlayer(contentsOf: url);
        soundPlayer.play();
        
    }
}

